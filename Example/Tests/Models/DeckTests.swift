//
//  DeckTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class DeckTests: HSKitTestCase {
    func testDecodeFromValidData() throws {
        let data = openSampleFile(.deck)
        let deck = try JSONDecoder().decode(Deck.self, from: data)
        XCTAssertEqual(deck.version, 0)
        XCTAssertEqual(deck.format, "standard")
        XCTAssertEqual(deck.hero.id.rawValue, 7)
        XCTAssertEqual(deck.heroPower.id.rawValue, 725)
        XCTAssertEqual(deck.class.id.rawValue, 10)
        XCTAssertEqual(deck.cards.numberOfCards, 30)
        XCTAssertEqual(deck.cards.numberOfSlots, 18)

    }
}