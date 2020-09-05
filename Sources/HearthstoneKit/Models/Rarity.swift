//
//  Rarity.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation
import SwiftUI

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
        


        // MARK: - Constants
        
        public var gemColor: Color? {
            switch self {
            case .common: return Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1) // HEX: #FFFFFF
            case .free, .unknown: return nil
            case .rare: return Color(.sRGB, red: 0, green: 0.44, blue: 0.87, opacity: 1) // HEX: #0070DD
            case .epic: return Color(.sRGB, red: 0.64, green: 0.21, blue: 0.93, opacity: 1) // HEX: #A336ED
            case .legendary: return Color(.sRGB, red: 1, green: 0.5, blue: 0, opacity: 1) // HEX: #FF7F00
            }
        }
    }
}

#if canImport(UIKit)

import UIKit.UIColor

public extension Rarity.Kind {
    var gemUIColor: UIColor? {
        switch self {
        case .common: return  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // HEX: #FFFFFF
        case .free, .unknown: return nil
        case .rare: return #colorLiteral(red: 0, green: 0.44, blue: 0.87, alpha: 1) // HEX: #0070DD
        case .epic: return #colorLiteral(red: 0.64, green: 0.21, blue: 0.93, alpha: 1) // HEX: #A336ED
        case .legendary: return #colorLiteral(red: 1, green: 0.5, blue: 0, alpha: 1) // HEX: #FF7F00
        }
    }
}

#endif
