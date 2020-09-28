//
//  Deck.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct Deck: Codable, Hashable {
    public let version: Int
    public let format: String
    public let hero: Card
    public let heroPower: Card
    public let `class`: PlayerClass
    public let cards: Decklist
    
    public init(version: Int, format: String, hero: Card, heroPower: Card, class: PlayerClass, cards: Decklist) {
        self.version = version
        self.format = format
        self.hero = hero
        self.heroPower = heroPower
        self.class = `class`
        self.cards = cards
    }
}
