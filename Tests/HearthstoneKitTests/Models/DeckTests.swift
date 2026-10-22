//
//  DeckTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

struct DeckTests {
    @Test func `Decode from valid data`() throws {
        let deck = try JSONDecoder().decode(Deck.self, from: openSampleFile(.deck))
        #expect(deck.version == 0)
        #expect(deck.format == "standard")
        #expect(deck.hero.id == 7)
        #expect(deck.heroPower.id == 725)
        #expect(deck.class.id == 10)
        #expect(deck.decklist.numberOfCards == 30)
        #expect(deck.decklist.numberOfSlots == 18)
    }
}
