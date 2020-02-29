//
//  GameMode.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct GameMode: Codable, Hashable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
    public var kind: Kind { Kind(slug: slug) }
    
    public enum Kind {
        case constructed
        case battlegrounds
        case arena
        case unknown
        
        public init(slug: String) {
            switch slug {
            case "constructed": self = .constructed
            case "battlegrounds": self = .battlegrounds
            case "arena": self = .arena
            default: self = .unknown
            }
        }
    }
}