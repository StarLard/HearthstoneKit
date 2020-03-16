//
//  MetadataKind.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/15/20.
//

import Foundation

public protocol Metadata: Codable, Hashable {
    static var metadataKind: MetadataKind { get }
}

public enum MetadataKind: String {
    case sets
    case setGroups
    case types
    case rarities
    case classes
    case minionTypes
    case keywords
}
