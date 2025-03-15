//
//  CardBack.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// Represents a card back which is equipable by the player.
public struct CardBack: Codable, Hashable, Identifiable {
    public let id: BlizzardIdentifier
    public let sortCategoryID: BlizzardIdentifier
    public let text: String
    public let name: String
    public let image: URL
    public let slug: String
    
    public init(id: BlizzardIdentifier, sortCategoryID: BlizzardIdentifier, text: String, name: String, image: URL, slug: String) {
        self.id = id
        self.sortCategoryID = sortCategoryID
        self.text = text
        self.name = name
        self.image = image
        self.slug = slug
    }
    
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
    public struct SortCategory: Codable, Hashable, Identifiable {
        public let id: BlizzardIdentifier
        public let name: String
        public let slug: String
        
        public init(id: BlizzardIdentifier, name: String, slug: String) {
            self.id = id
            self.name = name
            self.slug = slug
        }
    }
}
