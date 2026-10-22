//
//  DeckstringTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Testing
@testable import HearthstoneKit

struct DeckstringTests {
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

    private static let deckcodeWithoutHeader = "AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA"

    private static let deckcodeWithHeader = """
        ### We go face\n
        AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA\n
        # To use this deck, copy it to your clipboard and create a new deck in Hearthstone\n
        """

    // MARK: Importing

    @Test(arguments: [
        (deckcodeWithoutHeader, nil),
        (deckcodeWithHeader, "We go face"),
    ] as [(String, String?)])
    func importing(deckcode: String, expectedName: String?) throws {
        let deckstring = try Deckstring(deckcode: deckcode)
        #expect(deckstring.deckcode == deckcode)
        #expect(deckstring.heroID == 31)
        #expect(deckstring.formatID == 2)
        #expect(deckstring.name == expectedName)
        #expect(deckstring.cards == Self.cardMap)
    }

    @Test func `Imported deckstrings are equal regardless of header`() throws {
        let deckstringWithoutHeader = try Deckstring(deckcode: Self.deckcodeWithoutHeader)
        let deckstringWithHeader = try Deckstring(deckcode: Self.deckcodeWithHeader)
        #expect(deckstringWithoutHeader == deckstringWithHeader)
    }

    // MARK: Exporting

    @Test(arguments: [nil, "We go face"])
    func exporting(name: String?) {
        let deckstring = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap, name: name)
        #expect(deckstring.heroID == 31)
        #expect(deckstring.formatID == 2)
        #expect(deckstring.name == name)
        #expect(deckstring.cards == Self.cardMap)
    }

    @Test func `Exported deckstrings are equal regardless of header`() {
        let deckstringWithoutHeader = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap)
        let deckstringWithHeader = Deckstring(formatID: 2, heroID: 31, cards: Self.cardMap, name: "We go face")
        #expect(deckstringWithoutHeader == deckstringWithHeader)
    }
}
