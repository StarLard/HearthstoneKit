//
//  Rarity.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct Rarity: Codable, Hashable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let craftingCost: [Int]
    public let dustValue: [Int]
    public let name: String
}
