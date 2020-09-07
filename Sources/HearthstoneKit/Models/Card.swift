//
//  Card.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// Represents an in-game Hearthstone card.
public struct Card: Codable, Hashable, Identifiable {
    // MARK: Properties
    
    public let id: BlizzardIdentifier
    /// Whether or not the card is collectible
    ///
    /// Collectible cards are cards that can be included in your in-game collection. Cards are uncollectible if they
    /// are generated by other cards or are available only through special brawls and single-player content.
    public let isCollectible: Bool
    public let slug: String
    public let classID: BlizzardIdentifier
    public let multiClassIDs: [BlizzardIdentifier]
    public let cardTypeID: BlizzardIdentifier
    public let cardSetID: BlizzardIdentifier
    public let rarityID: BlizzardIdentifier?
    public let artistName: String?
    public let health: Int?
    public let attack: Int?
    public let manaCost: Int
    public let durability: Int?
    public let armor: Int?
    public let name: String
    public let text: String?
    public let attributedText: NSAttributedString?
    public let image: URL?
    public let imageGold: URL?
    public let flavorText: String
    public let cropImage: URL?
    /// An array of IDs that correspond to keywords which can be fethched or used in a search.
    ///
    /// Keywords describe common effects on many cards. For example, a minion card with the Battlecry keyword
    /// does something when first played. A minion with the Rush keyword can attack another minion immediately.
    public let keywordIDs: [BlizzardIdentifier]?
    public let parentID: BlizzardIdentifier?
    public let childIDs: [BlizzardIdentifier]?
    
    // MARK: Decodable
    
    enum CodingKeys: String, CodingKey {
        case id
        case isCollectible = "collectible"
        case slug
        case classID = "classId"
        case multiClassIDs = "multiClassIds"
        case cardTypeID = "cardTypeId"
        case cardSetID = "cardSetId"
        case rarityID = "rarityId"
        case artistName
        case health
        case attack
        case manaCost
        case durability
        case armor
        case name
        case text
        case image
        case imageGold
        case flavorText
        case cropImage
        case keywordIDs = "keywordIds"
        case parentID = "parentId"
        case childIDs = "childIds"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(BlizzardIdentifier.self, forKey: .id)
        
        switch try values.decode(Int.self, forKey: .isCollectible) {
        case 0: isCollectible = false
        case 1: isCollectible = true
        case let unexpectedValue: throw DecodingError.dataCorruptedError(forKey: .isCollectible, in: values,
                                                        debugDescription: "Encountered unexpected collectible value: \(unexpectedValue)")
        }
        
        slug = try values.decode(String.self, forKey: .slug)
        classID = try values.decode(BlizzardIdentifier.self, forKey: .classID)
        multiClassIDs = try values.decode(Array<BlizzardIdentifier>.self, forKey: .multiClassIDs)
        cardTypeID = try values.decode(BlizzardIdentifier.self, forKey: .cardTypeID)
        cardSetID = try values.decode(BlizzardIdentifier.self, forKey: .cardSetID)
        rarityID = try values.decodeIfPresent(BlizzardIdentifier.self, forKey: .rarityID)
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
        health = try values.decodeIfPresent(Int.self, forKey: .health)
        attack = try values.decodeIfPresent(Int.self, forKey: .attack)
        durability = try values.decodeIfPresent(Int.self, forKey: .durability)
        armor = try values.decodeIfPresent(Int.self, forKey: .armor)
        manaCost = try values.decode(Int.self, forKey: .manaCost)
        name = try values.decode(String.self, forKey: .name)
        if let unparsedText = try values.decodeIfPresent(String.self, forKey: .text) {
            text = unparsedText
            let data = Data(unparsedText.utf8)
            attributedText = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } else {
            text = nil
            attributedText = nil
        }
        image = URL(string: try values.decode(String.self, forKey: .image))
        imageGold = URL(string: try values.decode(String.self, forKey: .imageGold))
        flavorText = try values.decode(String.self, forKey: .flavorText)
        cropImage = try values.decodeIfPresent(URL.self, forKey: .cropImage)
        keywordIDs = try values.decodeIfPresent(Array<BlizzardIdentifier>.self, forKey: .keywordIDs)
        parentID = try values.decodeIfPresent(BlizzardIdentifier.self, forKey: .parentID)
        childIDs = try values.decodeIfPresent(Array<BlizzardIdentifier>.self, forKey: .childIDs)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(isCollectible ? 1 : 0, forKey: .isCollectible)
        try container.encode(slug, forKey: .slug)
        try container.encode(classID, forKey: .classID)
        try container.encode(multiClassIDs, forKey: .multiClassIDs)
        try container.encode(cardTypeID, forKey: .cardTypeID)
        try container.encode(cardSetID, forKey: .cardSetID)
        try container.encode(rarityID, forKey: .rarityID)
        try container.encodeIfPresent(artistName, forKey: .artistName)
        try container.encodeIfPresent(health, forKey: .health)
        try container.encodeIfPresent(attack, forKey: .attack)
        try container.encodeIfPresent(durability, forKey: .durability)
        try container.encodeIfPresent(armor, forKey: .armor)
        try container.encode(manaCost, forKey: .manaCost)
        try container.encode(name, forKey: .name)
        try container.encode(text ?? "", forKey: .text)
        try container.encode(image?.absoluteString ?? "", forKey: .image)
        try container.encode(imageGold?.absoluteString ?? "", forKey: .imageGold)
        try container.encode(flavorText, forKey: .flavorText)
        try container.encodeIfPresent(cropImage?.absoluteString, forKey: .cropImage)
        try container.encodeIfPresent(keywordIDs, forKey: .keywordIDs)
        try container.encodeIfPresent(parentID, forKey: .parentID)
        try container.encodeIfPresent(childIDs, forKey: .childIDs)
    }
}

// MARK: - Related Types

extension Card {
    // MARK: Keyword
    
    public struct Keyword: Metadata, Identifiable {
        public let id: BlizzardIdentifier
        public let slug: String
        public let name: String
        public let text: String
        public let referenceText: String
        public static let metadataKind: MetadataKind = .keywords
        
        enum CodingKeys: String, CodingKey {
            case id
            case slug
            case name
            case text
            case referenceText = "refText"
        }
    }
    
    // MARK: Card Type
    
    public struct CardType: Metadata, Identifiable {
        public let id: BlizzardIdentifier
        public let slug: String
        public let name: String
        public var kind: Kind { Kind(slug: slug) }
        public static let metadataKind: MetadataKind = .types
        
        public enum Kind {
            case hero
            case minion
            case spell
            case weapon
            case unknown
            
            public init(slug: String) {
                switch slug {
                case "hero": self = .hero
                case "minion": self = .minion
                case "spell": self = .spell
                case "weapon": self = .weapon
                default: self = .unknown
                }
            }
        }
    }
}
