//
//  ExpansionSetGroup.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct ExpansionSetGroup: Codable, Hashable {
    public let slug: String
    public let year: Int
    public let cardSets: [String]
    public let name: String
    public let isStandard: Bool
    public let icon: String
    
    enum CodingKeys: String, CodingKey {
        case slug
        case year
        case cardSets
        case name
        case isStandard = "standard"
        case icon
    }
}
