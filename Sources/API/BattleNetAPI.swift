//
//  BattleNetAPI.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import os.log

public enum BattleNetAPI {
    struct AccessToken: Codable, Hashable, Sendable {
        let value: String
        let type: String
        let expiration: Date
        let authorization: Authorization?
        let region: OAuthAPIRegion
        
        var isExpired: Bool {
            return Date() >= expiration
        }
        
        init(response: Response, requestTime: Date, authorization: Authorization?, region: OAuthAPIRegion) {
            value = response.value
            type = response.type
            expiration = requestTime.advanced(by: response.lifespan)
            self.authorization = authorization
            self.region = region
        }
        
        struct Response: Decodable, Sendable {
            let value: String
            let type: String
            let lifespan: TimeInterval
            
            enum CodingKeys: String, CodingKey {
                case value = "access_token"
                case type = "token_type"
                case lifespan = "expires_in"
            }
        }
    }
    
    public struct Authorization: Codable, Hashable, Sendable {
        /// The authorization code received from the authorization server.
        let authorizationCode: String
        /// Must be identical to the `redirect_uri` value used in the authorization request.
        let redirectURI: String
        /// The scopes needed for the access token. Note that this can be fewer scopes than the authorization.
        let scopes: String?
        let region: OAuthAPIRegion
    }
    
    /// Authenticates your app with Blizzard's servers.
    ///
    /// You can call this method at startup after calling 'HearthstoneKit.Configure' to pre-authenticate your app with Blizzard. If you
    /// don't, HearthstoneKit will authenticate for you the next time you make an API request. You should also call this method if the
    /// user's API region changes.
    ///
    /// Your app can optionally provide an authorization code if you would like requests to use the
    /// [authorization code flow](https://develop.battle.net/documentation/guides/using-oauth/authorization-code-flow)
    /// for oauth, which allows access to the authorized scopes. If you do not provide an authorization code, HearthstoneKit will use the
    /// [client credentials flow](https://develop.battle.net/documentation/guides/using-oauth/client-credentials-flow).
    /// See the [using oauth](https://develop.battle.net/documentation/guides/using-oauth) guide
    /// for more information.
    ///
    /// - Note: The only method in HearthstoneKit at this time that requires user authorization is `getUserInfo(session:region:)`.
    ///
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - region: The user's region. If providing an authorization code, this should match the region for which the code was generated.
    ///   - authorization: (Optional) The authorization request data and code obtained from the 'oauth/authorize' endpoint.
    ///   - forceRefresh: (Optional) You can force a new token to be requested, ignoring any locally stored ones, by passing `true`.
    ///   Defaults to `false`.
    ///
    /// - Note: The only endpoint supported by HearthstoneKit at this time that requires user authorization is `userInfo(for:)`
    public static func authenticateIfNeeded(with session: URLSession = .shared, for region: OAuthAPIRegion, authorization: Authorization?,
                                            forceRefresh: Bool = false) async throws {
        guard !forceRefresh else {
            _ = try await requestAccessToken(with: session, for: region, authorization: authorization)
            return
        }
        _ = try await getAccessToken(with: session, for: region, authorization: authorization)
    }
    
    public static func getUserInfo(with session: URLSession = .shared, for region: OAuthAPIRegion) async throws -> BattleNetUserInfo {
        let accessToken = try await getAccessToken(with: session, for: region)
        return try await requestUserInfo(with: accessToken, session: session, for: region)
    }
}

// MARK: Internal

internal extension BattleNetAPI {
    static func getAccessToken(with session: URLSession, for region: OAuthAPIRegion, authorization: Authorization? = nil) async throws -> AccessToken {
        if let token = retrieveAccessToken() {
            if validateAccessToken(token, for: region, authorization: authorization) {
                logger.trace("Local access token is still valid. Using local token.")
                return token
            } else {
                logger.info("Local access token is no longer valid. Requesting new token.")
            }
        }
        return try await requestAccessToken(with: session, for: region, authorization: authorization)
    }

    /// Builds a token request that authenticates the client with HTTP Basic auth and sends the grant as a form-encoded body,
    /// as Blizzard recommends, so credentials never appear in the URL.
    static func accessTokenRequest(for region: OAuthAPIRegion, authorization: Authorization?, clientID: String, clientSecret: String) -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = region.host
        components.path = "/token"

        var parameters: [(name: String, value: String)]
        if let authorization = authorization {
            parameters = [
                ("grant_type", "authorization_code"),
                ("code", authorization.authorizationCode),
                ("redirect_uri", authorization.redirectURI)
            ]
            if let scopes = authorization.scopes {
                parameters.append(("scope", scopes))
            }
        } else {
            parameters = [("grant_type", "client_credentials")]
        }

        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        let credentials = Data("\(clientID):\(clientSecret)".utf8).base64EncodedString()
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = Data(parameters.map({ "\($0.name)=\(formEncoded($0.value))" }).joined(separator: "&").utf8)
        return request
    }

    /// Percent-encodes everything except unreserved characters, so values like redirect URIs can't break the form body.
    private static func formEncoded(_ value: String) -> String {
        let unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        return value.addingPercentEncoding(withAllowedCharacters: unreserved) ?? value
    }
}

// MARK: Private

private extension BattleNetAPI {
    private static let decoder = JSONDecoder()

    static func storeAccessToken(_ accessToken: AccessToken) {
        do {
            let tokenData = try JSONEncoder().encode(accessToken)
            Keychain.storeData(tokenData, for: .battleNetAccessToken)
        } catch {
            logger.critical("Error encoding access token for keychain storage: \(error.localizedDescription, privacy: .public)")
        }
    }
    
    static func retrieveAccessToken() -> AccessToken? {
        guard let tokenData = Keychain.retrieveData(for: .battleNetAccessToken) else { return nil }
        do {
            return try JSONDecoder().decode(AccessToken.self, from: tokenData)
        } catch {
            logger.critical("Error decoding access token from keychain: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
    static func validateAccessToken(_ accessToken: AccessToken, for region: OAuthAPIRegion, authorization: Authorization?) -> Bool {
        return !accessToken.isExpired && accessToken.region == region && accessToken.authorization == authorization
    }
    
    static func requestAccessToken(with session: URLSession, for region: OAuthAPIRegion, authorization: Authorization?) async throws -> AccessToken {
        let configuration = await HearthstoneKit.configuration
        let request = accessTokenRequest(for: region, authorization: authorization, clientID: configuration.clientID,
                                         clientSecret: configuration.clientSecret)
        let requestTime = Date()

        let accessTokenResponse = try await session.value(AccessToken.Response.self, for: request, using: decoder)
        let accessToken = AccessToken(
            response: accessTokenResponse,
            requestTime: requestTime,
            authorization: authorization,
            region: region
        )
        logger.info("New access token recieved. Storing new token.")
        storeAccessToken(accessToken)
        return accessToken
    }
    
    static func requestUserInfo(with accessToken: BattleNetAPI.AccessToken, session: URLSession, for region: OAuthAPIRegion) async throws -> BattleNetUserInfo {
        var components = URLComponents()
        components.scheme = "https"
        components.host = region.host
        components.path = "/userinfo"
        var request: URLRequest = URLRequest(url: components.url!)
        request.setValue("Bearer \(accessToken.value)", forHTTPHeaderField: "Authorization")
        return try await session.value(BattleNetUserInfo.self, for: request, using: decoder)
    }
}

private let logger = Logger(category: "battle-net-api")
