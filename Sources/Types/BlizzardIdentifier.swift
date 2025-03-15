//
//  BlizzardIdentifier.swift
//  Pods-HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// A type that servers as a wrapper around `Int` to enforce type restrictions on identifiers.
public struct BlizzardIdentifier: Hashable, RawRepresentable, LosslessStringConvertible, CustomDebugStringConvertible, Codable, ExpressibleByIntegerLiteral, Sendable {
    // MARK: Properties
    
    public let rawValue: String
    public var description: String { return rawValue }
    public var intValue: Int? { return Int(rawValue) }
    
    public var debugDescription: String {
        return "\(String(reflecting: Self.self))(\(String(reflecting: rawValue)))"
    }
    
    // MARK: Init
    
    public init?(_ description: String) {
        self.init(rawValue: description)
    }
    
    public init?(rawValue: String) {
        guard Int(rawValue) != nil || rawValue == "*" else { return nil }
        self.rawValue = rawValue
    }
    
    public init(rawValue: Int) {
        self.rawValue = String(rawValue)
    }
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        do {
            rawValue = String(try values.decode(Int.self))
        } catch {
            let intDecodeError = error
            do {
                let stringValue = String(try values.decode(String.self))
                guard stringValue == "*" else {
                    throw DecodingError.dataCorruptedError(in: values, debugDescription: "String value for ID did not match wildcard character '*'.")
                }
                rawValue = stringValue
            } catch {
                throw intDecodeError
            }
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = intValue {
            try container.encode(value)
        } else {
            try container.encode(rawValue)
        }
    }
}
