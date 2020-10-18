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
        assertDoesNotThrow(try JSONDecoder().decode(Deck.self, from: data)) { (deck) in
            XCTAssertEqual(deck.version, 0)
            XCTAssertEqual(deck.format, "standard")
            XCTAssertEqual(deck.hero.id, 7)
            XCTAssertEqual(deck.heroPower.id, 725)
            XCTAssertEqual(deck.class.id, 10)
            XCTAssertEqual(deck.decklist.numberOfCards, 30)
            XCTAssertEqual(deck.decklist.numberOfSlots, 18)
        }
    }
}
