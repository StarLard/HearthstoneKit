//
//  MetadataSummary.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/15/20.
//

import Foundation

public struct MetadataSummary: Decodable {
    let sets: Set<ExpansionSet>
    let setGroups: Set<ExpansionSet.Group>
    let arenaIDs: Set<BlizzardIdentifier>
    let types: Set<Card.CardType>
    let rarities: Set<Rarity>
    let classes: Set<PlayerClass>
    let minionTypes: Set<MinionType>
    let gameModes: Set<GameMode>
    let keywords: Set<Card.Keyword>
    let filterableFields: Set<String>
    let numericFields: Set<String>
    let cardBackCategories: Set<CardBack.SortCategory>
    
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
