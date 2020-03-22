//
//  Keychain.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Security
import os.log

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
    
    enum Service: String {
        case battleNetAccessToken = "com.hearthstone-kit.battle-net-api-access-token"
    }
    
    // MARK: Methods
    
    /// Adds a key to the device keychain for secure storage
    ///
    /// - Parameters:
    ///   - service: A unique name which the key will be stored under
    ///   - value: `Data` representing an acceess token
    /// - Returns: True if the operation was successful, false otherwise
    @discardableResult
    static func storeData(_ data: Data, for service: Service) -> Bool {
        guard retrieveData(for: service) == nil else {
            return updateData(data, for: service)
        }
        let keychainQuery = newTokenKeychainQuery(with: data, for: service)
        let status = SecItemAdd(keychainQuery, nil)
        guard status == errSecSuccess else {    // Always check the status
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(.error, "Error storing data in keychain for \(service.rawValue) service: \(errorMessage)")
            } else {
                HSKLog.log(.error, "Error storing data in keychain for \(service.rawValue) service.")
            }
            return false
        }
        return true
    }
    
    /// Retrieves a specified key from the devices keychain
    ///
    /// - Parameter service: The name of the key to be retrieved
    /// - Returns: `Data` representing an acceess token
    static func retrieveData(for service: Service) -> Data? {
        let keychainQuery = existingTokenKeychainQuery(for: service)
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        
        guard status == errSecSuccess, let data = dataTypeRef as? Data else {
            let logLevel: OSLogType = status == errSecItemNotFound ? .info : .error
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(logLevel, "Error loading data from keychain for \(service.rawValue) service: \(errorMessage)")
            } else {
                HSKLog.log(logLevel, "Error loading data from keychain for \(service.rawValue) service.")
            }
            return nil
        }
        return data
    }
    
    /// Retrieves a specified key from the devices keychain
    ///
    /// - Parameter service: The name of the key to be retrieved
    /// - Returns: `Data` representing an acceess token
    @discardableResult
    static func clearData(for service: Service) -> Bool {
        let keychainQuery = clearExistingTokenKeychainQuery(for: service)
        let status = SecItemDelete(keychainQuery)
        
        guard status == errSecSuccess else {
            let logLevel: OSLogType = status == errSecItemNotFound ? .info : .error
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(logLevel, "Error clearing data from keychain for \(service.rawValue) service: \(errorMessage)")
            } else {
                HSKLog.log(logLevel, "Error clearing data from keychain for \(service.rawValue) service.")
            }
            return false
        }
        return true
    }
    
    private static func updateData(_ data: Data , for service: Service) -> Bool {
        let keychainQuery = existingTokenKeychainQuery(for: service)
        let status = SecItemUpdate(keychainQuery, [QueryKeys.data: data] as CFDictionary)
        guard status == errSecSuccess else {
            if let errorMessage = SecCopyErrorMessageString(status, nil) as String? {
                HSKLog.log(.error, "Error updating data in keychain for \(service.rawValue) service: \(errorMessage)")
            } else {
                HSKLog.log(.error, "Error updating data in keychain for \(service.rawValue) service.")
            }
            return false
        }
        return true
    }
    
    private static func clearExistingTokenKeychainQuery(for service: Service) -> CFDictionary {
        return [QueryKeys.class: QueryValues.class,
                QueryKeys.service: service.rawValue,
                QueryKeys.account: QueryValues.account] as CFDictionary
    }
    
    
    private static func existingTokenKeychainQuery(for service: Service) -> CFDictionary {
        return [QueryKeys.class: QueryValues.class,
                QueryKeys.service: service.rawValue,
                QueryKeys.account: QueryValues.account,
                QueryKeys.returnData: kCFBooleanTrue as Any,
                QueryKeys.limit: QueryValues.limit] as CFDictionary
    }
    
    private static func newTokenKeychainQuery(with tokenData: Data, for service: Service) -> CFDictionary {
        return [QueryKeys.class: QueryValues.class,
                QueryKeys.service: service.rawValue,
                QueryKeys.account: QueryValues.account,
                QueryKeys.data: tokenData] as CFDictionary
    }
}

