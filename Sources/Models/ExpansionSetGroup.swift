//
//  ExpansionSetGroup.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

extension ExpansionSet {
    public struct Group: Metadata {
        public let slug: String
        public let year: Int?
        public let cardSets: [String]
        public let name: String
        public let isStandard: Bool?
        public let icon: String?
        public static let metadataKind: MetadataKind = .setGroups
        
        public init(slug: String, year: Int?, cardSets: [String], name: String, isStandard: Bool?, icon: String?) {
            self.slug = slug
            self.year = year
            self.cardSets = cardSets
            self.name = name
            self.isStandard = isStandard
            self.icon = icon
        }
        
        enum CodingKeys: String, CodingKey {
            case slug
            case year
            case cardSets
            case name
            case isStandard = "standard"
            case icon
        }
    }
}
