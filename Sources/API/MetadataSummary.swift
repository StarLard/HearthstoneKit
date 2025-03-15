//
//  MetadataSummary.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/15/20.
//

import Foundation

public struct MetadataSummary: Codable {
    public let sets: Set<ExpansionSet>
    public let setGroups: Set<ExpansionSet.Group>
    public let arenaIDs: Set<BlizzardIdentifier>
    public let types: Set<Card.CardType>
    public let rarities: Set<Rarity>
    public let classes: Set<PlayerClass>
    public let minionTypes: Set<MinionType>
    public let gameModes: Set<GameMode>
    public let keywords: Set<Card.Keyword>
    public let filterableFields: Set<String>
    public let numericFields: Set<String>
    public let cardBackCategories: Set<CardBack.SortCategory>
    
    enum CodingKeys: String, CodingKey {
        case sets
        case setGroups
        case arenaIDs = "arenaIds"
        case types
        case rarities
        case classes
        case minionTypes
        case gameModes
        case keywords
        case filterableFields
        case numericFields
        case cardBackCategories
    }
}
