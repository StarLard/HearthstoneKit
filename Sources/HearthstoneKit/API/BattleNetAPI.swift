//
//  BattleNetAPI.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Combine
import os.log

public enum BattleNetAPI {
    struct AccessToken: Codable, Equatable {
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
        
        struct Response: Decodable {
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
    
    public struct Authorization: Equatable, Codable {
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
                                            forceRefresh: Bool = false) -> AnyPublisher<Void, Error> {
        guard !forceRefresh  else {
            return requestAccessToken(with: session, for: region, authorization: authorization)
                .map { (token) -> Void in return () }
                .eraseToAnyPublisher()
        }
        return getAccessToken(with: session, for: region, authorization: authorization)
            .map { (token) -> Void in return () }
            .eraseToAnyPublisher()
    }
    
    public static func getUserInfo(with session: URLSession = .shared, for region: OAuthAPIRegion) -> AnyPublisher<BattleNetUserInfo, Error> {
        return getAccessToken(with: session, for: region).flatMap({ (accessToken) -> AnyPublisher<BattleNetUserInfo, Error> in
            return requestUserInfo(with: accessToken, session: session, for: region)
        }).eraseToAnyPublisher()
    }
}

// MARK: Internal

internal extension BattleNetAPI {
    static func getAccessToken(with session: URLSession, for region: OAuthAPIRegion, authorization: Authorization? = nil) -> AnyPublisher<AccessToken, Error> {
        if let token = retrieveAccessToken() {
            if validateAccessToken(token, for: region, authorization: authorization) {
                logger.trace("Local access token is still valid. Using local token.")
                return Just(token).setFailureType(to: Error.self).eraseToAnyPublisher()
            } else {
                logger.info("Local access token is no longer valid. Requesting new token.")
            }
        }
        return requestAccessToken(with: session, for: region, authorization: authorization)
    }
}

// MARK: Private

private extension BattleNetAPI {
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
    
    static func requestAccessToken(with session: URLSession, for region: OAuthAPIRegion, authorization: Authorization?) -> AnyPublisher<AccessToken, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = region.host
        components.path = "/oauth/token"
        let queryItems: [URLQueryItem]
        if let authorization = authorization {
            var items = [
                URLQueryItem(name: "code", value: authorization.authorizationCode),
                URLQueryItem(name: "redirect_uri", value: authorization.redirectURI)
            ]
            if let scopes = authorization.scopes {
                items.append(URLQueryItem(name: "scope", value: scopes))
            }
            queryItems = items
        } else {
            queryItems = [
                URLQueryItem(name: "client_id", value: HearthstoneKit.configuration.clientID),
                URLQueryItem(name: "client_secret", value: HearthstoneKit.configuration.clientSecret)
            ]
        }
        components.queryItems = queryItems
        var request: URLRequest = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        let grantType = authorization == nil ? "client_credentials" : "authorization_code"
        request.httpBody = "grant_type=\(grantType)".data(using: .utf8)
        
        let requestTime = Date()
        
        return session.dataTaskPublisher(for: request)
            .tryExtractData()
            .decode(type: AccessToken.Response.self, decoder: JSONDecoder())
            .map({ (response) -> AccessToken in
                AccessToken(response: response, requestTime: requestTime, authorization: authorization, region: region)
            })
            .handleEvents(receiveOutput: { (accessToken) in
                logger.info("New access token recieved. Storing new token.")
                storeAccessToken(accessToken)
            })
            .eraseToAnyPublisher()
    }
    
    static func requestUserInfo(with accessToken: BattleNetAPI.AccessToken, session: URLSession, for region: OAuthAPIRegion) -> AnyPublisher<BattleNetUserInfo, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = region.host
        components.path = "/oauth/userinfo"
        var request: URLRequest = URLRequest(url: components.url!)
        request.setValue("Bearer \(accessToken.value)", forHTTPHeaderField: "Authorization")
        return session.dataTaskPublisher(for: request)
            .tryExtractData()
            .decode(type: BattleNetUserInfo.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

private let logger = Logger(category: "battle-net-api")
