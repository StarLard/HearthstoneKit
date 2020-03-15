//
//  Keychain.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Security

enum Keychain {
    
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
        static let account = "com.calebfriden.hearthstone-kit"
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

