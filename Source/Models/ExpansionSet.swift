//
//  ExpansionSet.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct ExpansionSet: Codable, Hashable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let releaseDate: Date
    public let name: String
    public let type: String
    public let collectibleCount: Int
    public let collectibleRevealedCount: Int
    public let nonCollectibleCount: Int
    public let nonCollectibleRevealedCount: Int
}
