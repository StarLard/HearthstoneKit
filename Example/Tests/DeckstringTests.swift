//
//  DeckstringTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

import XCTest
@testable import HearthstoneKit

final class DeckstringTests: HSKitTestCase {
    private static let cardMap: [BlizzardIdentifier: Int] = [
        877: 1,
        903: 1,
        48519: 1,
        52894: 1,
        49824: 1,
        50644: 1,
        606: 1,
        1047: 1,
        53924: 1,
        455: 1,
        55288: 2,
        55292: 2,
        52076: 2,
        55301: 2,
        585: 2,
        896: 2,
        519: 2,
        141: 2,
        1091: 2,
        1281: 2
    ]
    
    func testImporting() throws {
        try XCTContext.runActivity(named: "Test importing without header") { _ in
            let deckstring = try Deckstring(rawValue: "AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA")
            XCTAssertEqual(deckstring.rawValue, "AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA")
            XCTAssertEqual(deckstring.heroID, 31)
            XCTAssertEqual(deckstring.formatID, 2)
            XCTAssertNil(deckstring.name)
            XCTAssertEqual(deckstring.cards, Self.cardMap)
        }
        try XCTContext.runActivity(named: "Test importing with header") { _ in
            let deckstring = try Deckstring(rawValue: """
                ### We go face\n
                AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA\n
                # To use this deck, copy it to your clipboard and create a new deck in Hearthstone\n
                """)
            XCTAssertEqual(deckstring.rawValue, """
            ### We go face\n
            AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA\n
            # To use this deck, copy it to your clipboard and create a new deck in Hearthstone\n
            """)
            XCTAssertEqual(deckstring.heroID, 31)
            XCTAssertEqual(deckstring.formatID, 2)
            XCTAssertEqual(deckstring.name, "We go face")
            XCTAssertEqual(deckstring.cards, Self.cardMap)
        }
        try XCTContext.runActivity(named: "Test deckstring equality") { _ in
            let deckstringWithoutHeader = try Deckstring(rawValue: "AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA")
            let deckstringWithHeader = try Deckstring(rawValue: """
                ### We go face\n
                AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA\n
                # To use this deck, copy it to your clipboard and create a new deck in Hearthstone\n
                """)
            XCTAssertEqual(deckstringWithoutHeader, deckstringWithHeader)
        }
    }
    
    func testExporting() {
        XCTContext.runActivity(named: "Test exporting without header") { _ in
            let deckstring = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap)
            XCTAssertEqual(deckstring.heroID, 31)
            XCTAssertEqual(deckstring.formatID, 2)
            XCTAssertNil(deckstring.name)
            XCTAssertEqual(deckstring.cards, Self.cardMap)
        }
        XCTContext.runActivity(named: "Test exporting with header") { _ in
            let deckstring = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap, name: "We go face")
            XCTAssertEqual(deckstring.heroID, 31)
            XCTAssertEqual(deckstring.formatID, 2)
            XCTAssertEqual(deckstring.name, "We go face")
            XCTAssertEqual(deckstring.cards, Self.cardMap)
        }
        XCTContext.runActivity(named: "Test deckstring equality") { _ in
            let deckstringWithoutHeader = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap)
            let deckstringWithHeader = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap, name: "We go face")
            XCTAssertEqual(deckstringWithoutHeader, deckstringWithHeader)
        }
    }
}
