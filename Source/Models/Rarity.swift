//
//  Rarity.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct Rarity: Metadata {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
    public let craftingCost: CardFormValue
    public let dustValue: CardFormValue
    public var kind: Kind { Kind(slug: slug) }
    public static let metadataKind: MetadataKind = .rarities
    
    public struct CardFormValue: Codable, Hashable {
        public let regular: Int?
        public let golden: Int?
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let values = try container.decode(Array<Int?>.self)
            guard values.count == 2 else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unexpected number of values")
            }
            regular = values[0]
            golden = values[1]
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            let values = [regular, golden]
            try container.encode(values)
        }
    }
    
    public enum Kind {
        case common
        case free
        case rare
        case epic
        case legendary
        case unknown
        
        public init(slug: String) {
            switch slug {
            case "common": self = .common
            case "free": self = .free
            case "rare": self = .rare
            case "epic": self = .epic
            case "legendary": self = .legendary
            default: self = .unknown
            }
        }
    }
}
