//
//  MinionType.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct MinionType: Metadata, Identifiable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
    public var kind: Kind { Kind(slug: slug) }
    public static let metadataKind: MetadataKind = .minionTypes
    
    public init(id: BlizzardIdentifier, slug: String, name: String) {
        self.id = id
        self.slug = slug
        self.name = name
    }
    
    public enum Kind {
        case murloc
        case demon
        case mech
        case elemental
        case beast
        case totem
        case pirate
        case dragon
        case all
        case unknown
        
        public init(slug: String) {
            switch slug {
            case "murloc": self = .murloc
            case "demon": self = .demon
            case "mech": self = .mech
            case "elemental": self = .elemental
            case "beast": self = .beast
            case "totem": self = .totem
            case "pirate": self = .pirate
            case "dragon": self = .dragon
            case "all": self = .all
            default: self = .unknown
            }
        }
    }
}
