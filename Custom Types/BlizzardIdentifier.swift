//
//  BlizzardIdentifier.swift
//  Pods-HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// A type that servers as a wrapper around `Int` to enforce type restrictions on identifiers.
public struct BlizzardIdentifier: Hashable, RawRepresentable, LosslessStringConvertible, CustomDebugStringConvertible, Codable {
    
    // MARK: Properties
    
    public let rawValue: Int
    
    public var description: String {
        return rawValue.description
    }
    
    public var debugDescription: String {
        return "\(String(reflecting: Self.self))(\(String(reflecting: rawValue)))"
    }
    
    // MARK: Init
    
    public init?(_ description: String) {
        if let intValue =  Int(description) {
            self.init(rawValue: intValue)
        }
        return nil
    }
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
