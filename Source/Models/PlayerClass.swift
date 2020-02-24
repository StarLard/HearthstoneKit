//
//  PlayerClass.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct PlayerClass: Codable, Hashable {
    public let id: BlizzardIdentifier
    public let cardID: BlizzardIdentifier?
    public let slug: String
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case cardID = "cardId"
        case slug
        case name
    }
}
