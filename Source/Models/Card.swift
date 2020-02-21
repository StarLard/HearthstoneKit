//
//  Card.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

public struct Card: Decodable {
    // MARK: Properties
    
    public let id: BlizzardIdentifier
    public let isCollectible: Bool
    public let slug: String
    public let classID: BlizzardIdentifier
    public let multiClassIDs: [BlizzardIdentifier]
    public let cardTypeID: BlizzardIdentifier
    public let cardSetID: BlizzardIdentifier
    public let rarityID: BlizzardIdentifier
    public let artistName: String
    public let health: Int
    public let attack: Int
    public let manaCost: Int
    public let name: String
    public let text: NSAttributedString
    public let image: URL
    public let imageGold: URL
    public let flavorText: String
    public let cropImage: URL
    public let keywordIDs: [BlizzardIdentifier]
    
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
        case name
        case text
        case image
        case imageGold
        case flavorText
        case cropImage
        case keywordIDs = "keywordIds"
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
        rarityID = try values.decode(BlizzardIdentifier.self, forKey: .rarityID)
        artistName = try values.decode(String.self, forKey: .artistName)
        health = try values.decode(Int.self, forKey: .health)
        attack = try values.decode(Int.self, forKey: .attack)
        manaCost = try values.decode(Int.self, forKey: .manaCost)
        name = try values.decode(String.self, forKey: .name)
        
        let unparsedText = try values.decode(String.self, forKey: .text)
        do {
            let data = Data(unparsedText.utf8)
            text = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            text = NSAttributedString(string: unparsedText)
        }
                
        image = try values.decode(URL.self, forKey: .image)
        imageGold = try values.decode(URL.self, forKey: .imageGold)
        flavorText = try values.decode(String.self, forKey: .flavorText)
        cropImage = try values.decode(URL.self, forKey: .cropImage)
        keywordIDs = try values.decode(Array<BlizzardIdentifier>.self, forKey: .keywordIDs)
    }
}
