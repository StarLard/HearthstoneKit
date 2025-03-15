//
//  PlayerClass.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct PlayerClass: Metadata, Identifiable {
    public let id: BlizzardIdentifier
    public let cardID: BlizzardIdentifier?
    public let slug: String
    public let name: String
    public var kind: Kind { Kind(slug: slug) }
    public static let metadataKind: MetadataKind = .classes
    
    public init(id: BlizzardIdentifier, cardID: BlizzardIdentifier?, slug: String, name: String) {
        self.id = id
        self.cardID = cardID
        self.slug = slug
        self.name = name
    }
    
    public enum Kind {
        case all
        case demonHunter
        case druid
        case hunter
        case mage
        case paladin
        case priest
        case rogue
        case shaman
        case warlock
        case warrior
        case neutral
        case unknown
        
        public init(slug: String) {
            switch slug {
            case "all": self = .all
            case "demonhunter": self = .demonHunter
            case "druid": self = .druid
            case "hunter": self = .hunter
            case "mage": self = .mage
            case "paladin": self = .paladin
            case "priest": self = .priest
            case "rogue": self = .rogue
            case "shaman": self = .shaman
            case "warlock": self = .warlock
            case "warrior": self = .warrior
            case "neutral": self = .neutral
            default: self = .unknown
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case cardID = "cardId"
        case slug
        case name
    }
}
