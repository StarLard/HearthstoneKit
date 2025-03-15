//
//  GameMode.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct GameMode: Codable, Hashable, Identifiable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
    public var kind: Kind { Kind(slug: slug) }
    
    public init(id: BlizzardIdentifier, slug: String, name: String) {
        self.id = id
        self.slug = slug
        self.name = name
    }
    
    public enum Kind: String {
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
