//
//  BattleNetAPI.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Combine

enum BattleNetAPI {
    struct AccessToken: Codable {
        let value: String
        let type: String
        let expiration: Date
        
        var isValid: Bool {
            return Date() < expiration
        }
        
        init(response: Response, requestTime: Date) {
            value = response.value
            type = response.type
            expiration = requestTime.advanced(by: response.lifespan)
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
    
    static func authenticate(with session: URLSession, for locale: PlayerLocale) -> AnyPublisher<AccessToken, Error> {
        let host = locale.oauthAPIRegion.host
        let service = "\(host)/oauth/token"
        if let tokenData = Keychain.retrieveTokenData(for: service) {
            do {
                let token = try JSONDecoder().decode(AccessToken.self, from: tokenData)
                if token.isValid {
                    return Just(token).setFailureType(to: Error.self).eraseToAnyPublisher()
                } else {
                    HSKLog.log(.info, "Cached access token has expired. Requesting new token.")
                }
            } catch {
                HSKLog.log(.error, "Error decoding access token from keychain.")
            }
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/oauth/token"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: HearthstoneKit.shared.configuration.clientID),
            URLQueryItem(name: "client_secret", value: HearthstoneKit.shared.configuration.clientSecret)
        ]
        var request: URLRequest = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        let requestTime = Date()
        
        return session.dataTaskPublisher(for: request)
            .tryExtractData()
            .decode(type: AccessToken.Response.self, decoder: JSONDecoder())
            .map({ (response) -> AccessToken in
                AccessToken(response: response, requestTime: requestTime)
            })
            .handleEvents(receiveOutput: { (accessToken) in
                do {
                    let tokenData = try JSONEncoder().encode(accessToken)
                    Keychain.storeTokenData(tokenData, for: service)
                } catch {
                    HSKLog.log(.error, "Error encoding access token for keychain storage.")
                }
            })
            .eraseToAnyPublisher()
    }
}
