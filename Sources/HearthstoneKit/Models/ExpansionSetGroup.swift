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
