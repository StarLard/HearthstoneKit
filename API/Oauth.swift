//
//  Oauth.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Combine
import Security

extension HearthstoneAPI {
    struct AccessToken: Codable {
        let value: String
        let type: String
        let expiration: Date
        let scope: String
        
        init(response: Response, requestTime: Date) {
            value = response.value
            type = response.type
            expiration = requestTime.advanced(by: response.lifespan)
            scope = response.scope
        }
        
        struct Response: Decodable {
            let value: String
            let type: String
            let lifespan: TimeInterval
            let scope: String
            
            enum CodingKeys: String, CodingKey {
                case value = "access_token"
                case type = "token_type"
                case lifespan = "expires_in"
                case scope
            }
        }
    }
    
    static func authenticate(with session: URLSession, for locale: PlayerLocale) -> AnyPublisher<AccessToken, Error> {
        let service = "\(locale.apiRegion.host.absoluteString)/oauth/token"
        if let tokenData = Keychain.retrieveTokenData(for: service) {
            do {
                let token = try JSONDecoder().decode(AccessToken.self, from: tokenData)
                return Just(token).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                HSKLog.log(.error, "Error decoding token from keychain.")
            }
        }
        
        var components = URLComponents()
        components.host = locale.apiRegion.host.absoluteString
        components.path = "oauth/token"
        components.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials")]
        var request: URLRequest = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        
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
                    HSKLog.log(.error, "Error encoding token for keychain storage.")
                }
            })
            .eraseToAnyPublisher()
    }

}

// MARK: - Keychain

private enum Keychain {
    
    // MARK: Constants
    
    private enum QueryKeys {
        static let `class` = NSString(format: kSecClass)
        static let account = NSString(format: kSecAttrAccount)
        static let data = NSString(format: kSecValueData)
        static let service = NSString(format: kSecAttrService)
        static let limit = NSString(format: kSecMatchLimit)
        static let returnData = NSString(format: kSecReturnData)
    }
    
    private enum QueryValues {
        static let limit = NSString(format: kSecMatchLimitOne)
        static let `class` = NSString(format: kSecClassGenericPassword)
        static let account = "com.starlard.hearthstone-kit"
    }
    
    // MARK: Methods
    
    
    /// Adds a key to the device keychain for secure storage
    ///
    /// - Parameters:
    ///   - forKey: A unique name which the key will be stored under
    ///   - value: A string representing the key
    /// - Returns: True if the operation was successful, false otherwise
    @discardableResult
    static func storeTokenData(_ tokenData: Data, for service: String) -> Bool {
        guard retrieveTokenData(for: service) == nil else {
            return updateTokenData(tokenData, for: service)
        }
        let keychainQuery = newTokenKeychainQuery(with: tokenData, for: service)
        let status = SecItemAdd(keychainQuery, nil)
        guard status == errSecSuccess else {    // Always check the status
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(.error, "Error storing token in keychain: \(errorMessage).")
            } else {
                HSKLog.log(.error, "Error storing token in keychain.")
            }
            return false
        }
        return true
    }
    
    /// Retrieves a specified key from the devices keychain
    ///
    /// - Parameter forKey: The name of the key to be retrieved
    /// - Returns: String representing the key if found, nil otherwise
    static func retrieveTokenData(for service: String) -> Data? {
        let keychainQuery = existingTokenKeychainQuery(for: service)
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(.error, "Error loading token from keychain: \(errorMessage).")
            } else {
                HSKLog.log(.error, "Error loading token from keychain.")
            }
            return nil
        }
        return data
    }
    
    private static func updateTokenData(_ tokenData: Data , for service: String) -> Bool {
        let keychainQuery = existingTokenKeychainQuery(for: service)
        let status = SecItemUpdate(keychainQuery, [QueryKeys.data: tokenData] as CFDictionary)
        guard status == errSecSuccess else {
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(.error, "Error updating token in keychain: \(errorMessage).")
            } else {
                HSKLog.log(.error, "Error updating token in keychain.")
            }
            return false
        }
        return true
    }
    
    
    private static func existingTokenKeychainQuery(for service: String) -> CFDictionary {
        return [QueryKeys.class: QueryValues.class,
                QueryKeys.service: service,
                QueryKeys.account: QueryValues.account,
                QueryKeys.returnData: kCFBooleanTrue as Any,
                QueryKeys.limit: QueryValues.limit] as CFDictionary
    }
    
    private static func newTokenKeychainQuery(with tokenData: Data, for service: String) -> CFDictionary {
        return [QueryKeys.class: QueryValues.class,
                QueryKeys.service: service,
                QueryKeys.account: QueryValues.account,
                QueryKeys.data: tokenData] as CFDictionary
    }
}

