//
//  HearthstoneKit.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/12/20.
//

import Foundation

/// Interfaces with Hearth Keeper API
public final class HearthstoneKit {
    // MARK: Internal Properties
    
    static let shared = HearthstoneKit()
    
    var configuration: Configuration {
        guard let config = _configuration else {
            preconditionFailure("`HearthstoneKit.configure()` must be called at app launch.")
        }
        return config
    }
    
    public struct Configuration {
        let clientID: String
        let clientSecret: String
        
        init?(configurationDictionary: NSDictionary) {
            guard let id = configurationDictionary["CLIENT_ID"] as? String,
                let secret = configurationDictionary["CLIENT_SECRET"] as? String else {
                return nil
            }
            clientID = id
            clientSecret = secret
        }
    }
    
    // MARK: Public Methods
    
    /// Configures a default Andiron app. Raises an exception if any configuration
    /// step fails. This method should be called after the app is launched and
    /// before using Andiron services. This method is thread safe and contains
    /// synchronous file I/O (reading GoogleService-Info.plist from disk).
    ///
    /// - Parameters:
    ///   - scheme: The custom URL scheme you have registered with your app.
    ///   - battleNetRedirectUrl: The redirect URL you have registered on
    /// the Battle.net developer portal.
    public static func configure() {
        guard let configurationDictionary = shared.defaultConfigurationDictionary() else {
            preconditionFailure("""
                `HearthstoneKit.configure()` could not find\n" a valid \(Self.configurationFileName).\(Self.configurationFileType)\n
                in your project. Please make one and include it in your app's bundle.
                """)
        }
        guard let configuration = Configuration(configurationDictionary: configurationDictionary) else {
            preconditionFailure("Configuration file was invalid. Please pass a valid configuration.")
        }
        configure(with: configuration)
    }
    
    public static func configure(with configuration: Configuration) {
        assert(Thread.isMainThread)
        guard shared._configuration == nil else {
            preconditionFailure("App name cannot be empty.")
        }
        HSKLog.log(.debug, "Configuring app.")
        shared._configuration = configuration
    }
    
    // MARK: Private Properties
    
    private static let configurationFileName = "HearthstoneKit-Configuration"
    private static let configurationFileType = "plist"
    private var _configuration: Configuration?
    private var appBundles: [Bundle] { [Bundle.main, Bundle(for: Self.self)] }
    
    // MARK: Private Methods
    
    private func pathForConfigurationDictionary(withResourceName resourceName: String, fileType: String, in bundles: [Bundle]) -> String? {
        for bundle in bundles {
            if let path = bundle.path(forResource: resourceName, ofType: fileType) {
                return path
            }
        }
        return nil
    }
    
    private func plistFilePath(withName fileName: String) -> String? {
        guard let plistFilePath = pathForConfigurationDictionary(withResourceName: fileName, fileType: Self.configurationFileType, in: appBundles) else {
            HSKLog.log(.error, "Could not locate configuration file: '\(fileName).\(Self.configurationFileType)'.")
            return nil
        }
        return plistFilePath
    }
    
    private func defaultConfigurationDictionary() -> NSDictionary? {
        guard let filePath = plistFilePath(withName: Self.configurationFileName), let configurationDictionary = NSDictionary(contentsOfFile: filePath) else {
            HSKLog.log(.error, "The configuration file is not a dictionary: \(Self.configurationFileName).\(Self.configurationFileType)")
            return nil
        }
        return configurationDictionary
    }
}
