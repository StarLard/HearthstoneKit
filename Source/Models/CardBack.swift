//
//  CardBack.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// Represents a card back which is equipable by the player.
public struct CardBack: Codable, Hashable {
    public let id: BlizzardIdentifier
    public let sortCategoryID: BlizzardIdentifier
    public let text: String
    public let name: String
    public let image: URL
    public let slug: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sortCategoryID = "sortCategory"
        case text
        case name
        case image
        case slug
    }
}

extension CardBack {
    public struct SortCategory: Codable {
        public let id: BlizzardIdentifier
        public let name: String
        public let slug: String
    }
}
