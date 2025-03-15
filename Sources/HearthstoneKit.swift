//
//  HearthstoneKit.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/12/20.
//

import Foundation
import os.log

/// Interfaces with Hearth Keeper API
@MainActor public final class HearthstoneKit {
    // MARK: Internal Properties
    
    static let shared = HearthstoneKit()
    
    public static var configuration: Configuration {
        guard let config = shared.configuration else {
            logger.fault("`HearthstoneKit.configure()` must be called at app launch.")
            fatalError("`HearthstoneKit.configure()` must be called at app launch.")
        }
        return config
    }
    
    public struct Configuration: Sendable {
        public let clientID: String
        public let clientSecret: String
        
        public init?(bundle: Bundle) {
            guard let filePath = bundle.path(forResource: Self.fileName, ofType: Self.fileType),
                  let configurationDictionary = NSDictionary(contentsOfFile: filePath) else { return nil }
            self.init(configurationDictionary: configurationDictionary)
        }
        
        public init?(configurationDictionary: NSDictionary) {
            guard let id = configurationDictionary["CLIENT_ID"] as? String,
                let secret = configurationDictionary["CLIENT_SECRET"] as? String else {
                return nil
            }
            clientID = id
            clientSecret = secret
        }
        
        fileprivate static let fileName = "HearthstoneKit-Configuration"
        fileprivate static let fileType = "plist"
    }
    
    // MARK: Public Methods
    
    /// Configures a default HearthstoneKit app. Raises an exception if any configuration
    /// step fails. This method should be called after the app is launched and
    /// before using HearthstoneKit services. This method is not thread safe and must
    /// be called on the main thread.
    public static func configure() {
        guard let configurationDictionary = shared.defaultConfigurationDictionary() else {
            preconditionFailure("""
                `HearthstoneKit.configure()` could not find\n" a valid \(Configuration.fileName).\(Configuration.fileType)\n
                in your project. Please make one and include it in your app's bundle.
                """)
        }
        guard let configuration = Configuration(configurationDictionary: configurationDictionary) else {
            preconditionFailure("Configuration file was invalid. Please pass a valid configuration.")
        }
        configure(with: configuration)
    }
    
    /// Configures a HearthstoneKit app with a custom configuration. Raises an exception
    /// if any configuration step fails. This method should be called after the app is launched
    /// and before using HearthstoneKit services. This method is not thread safe and must
    /// be called on the main thread.
    /// - Parameter configuration: A custom configuration for your app.
    public static func configure(with configuration: Configuration) {
        assert(Thread.isMainThread)
        guard shared.configuration == nil else {
            preconditionFailure("App has already been configured. Only call `HearthstoneKit.configure()` once per app launch.")
        }
        logger.info("Configuring app.")
        shared.configuration = configuration
    }
    
    // MARK: Private Properties
    
    private var configuration: Configuration?
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
        guard let plistFilePath = pathForConfigurationDictionary(withResourceName: fileName, fileType: Configuration.fileType, in: appBundles) else {
            logger.fault("Could not locate configuration file: '\(fileName,privacy: .public).\(Configuration.fileType, privacy: .public)'.")
            return nil
        }
        return plistFilePath
    }
    
    private func defaultConfigurationDictionary() -> NSDictionary? {
        guard let filePath = plistFilePath(withName: Configuration.fileName), let configurationDictionary = NSDictionary(contentsOfFile: filePath) else {
            logger.fault("The configuration file is not a dictionary: \(Configuration.fileName, privacy: .public).\(Configuration.fileType, privacy: .public)")
            return nil
        }
        return configurationDictionary
    }
}

private let logger = Logger(category: "configuration")
