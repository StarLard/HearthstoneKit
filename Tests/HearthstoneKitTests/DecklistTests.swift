//
//  DecklistTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class DecklistTests: HSKitTestCase {
    @MainActor func testDecklistFlows() throws {
        var decklist = try makeDecklist()
        let newCard = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardHeroSkin))
        let spell = try makeCard(.spell)
        let weapon = try makeCard(.weapon)
        let minion = try makeCard(.minion)
        let hero = try makeCard(.hero)
        
        XCTContext.runActivity(named: "Test that init creates sorted deck") { _ in
            XCTAssertEqual(decklist.numberOfCards, 5)
            XCTAssertEqual(decklist.numberOfSlots, 4)
            XCTAssertEqual(decklist[0].card, spell)
            XCTAssertEqual(decklist[0].quantity, 1)
            XCTAssertEqual(decklist[1].card, weapon)
            XCTAssertEqual(decklist[1].quantity, 1)
            XCTAssertEqual(decklist[2].card, minion)
            XCTAssertEqual(decklist[2].quantity, 2)
            XCTAssertEqual(decklist[3].card, hero)
            XCTAssertEqual(decklist[3].quantity, 1)
            XCTAssertEqual(decklist.cards, [spell, weapon, minion, minion, hero])
        }
        XCTContext.runActivity(named: "Test that binary search finds cards") { _ in
            XCTAssertEqual(decklist.contains(spell), 0)
            XCTAssertEqual(decklist.contains(weapon), 1)
            XCTAssertEqual(decklist.contains(minion), 2)
            XCTAssertEqual(decklist.contains(hero), 3)
            XCTAssertNil(decklist.contains(newCard))
        }
        XCTContext.runActivity(named: "Test that decrementing card not in the decklist does nothing") { _ in
            XCTAssertFalse(decklist.decrementCard(newCard))
            XCTAssertEqual(decklist.numberOfCards, 5)
            XCTAssertEqual(decklist.numberOfSlots, 4)
        }
        XCTContext.runActivity(named: "Test that incrementing an existing card increases quantity") { _ in
            XCTAssertTrue(decklist.incrementCard(spell))
            XCTAssertEqual(decklist.numberOfCards, 6)
            XCTAssertEqual(decklist.numberOfSlots, 4)
            XCTAssertEqual(decklist[0].card, spell)
            XCTAssertEqual(decklist[0].quantity, 2)
        }
        XCTContext.runActivity(named: "Test that incrementing limits are enforced") { _ in
            XCTAssertFalse(decklist.incrementCard(spell))
            XCTAssertEqual(decklist.numberOfCards, 6)
            XCTAssertEqual(decklist.numberOfSlots, 4)
            XCTAssertEqual(decklist[0].card, spell)
            XCTAssertEqual(decklist[0].quantity, 2)
            
            XCTAssertTrue(decklist.incrementCard(spell, slotLimit: 3))
            XCTAssertEqual(decklist.numberOfCards, 7)
            XCTAssertEqual(decklist.numberOfSlots, 4)
            XCTAssertEqual(decklist[0].card, spell)
            XCTAssertEqual(decklist[0].quantity, 3)
        }
        XCTContext.runActivity(named: "Test that decrementing an existing card decreases quantity") { _ in
            XCTAssertTrue(decklist.decrementCard(spell))
            XCTAssertEqual(decklist.numberOfCards, 6)
            XCTAssertEqual(decklist.numberOfSlots, 4)
            XCTAssertEqual(decklist.contains(spell), 0)
            XCTAssertEqual(decklist[0].card, spell)
            XCTAssertEqual(decklist[0].quantity, 2)
            
            XCTAssertTrue(decklist.decrementCard(weapon))
            XCTAssertEqual(decklist.numberOfCards, 5)
            XCTAssertEqual(decklist.numberOfSlots, 3)
            XCTAssertNil(decklist.contains(weapon))
            XCTAssertEqual(decklist[1].card, minion)
            XCTAssertEqual(decklist[1].quantity, 2)
        }
        XCTContext.runActivity(named: "Test that incrementing a new card increases quantity") { _ in
            XCTAssertTrue(decklist.incrementCard(newCard))
            XCTAssertEqual(decklist.numberOfCards, 6)
            XCTAssertEqual(decklist.numberOfSlots, 4)
            XCTAssertEqual(decklist.contains(newCard), 1)
            XCTAssertEqual(decklist[1].card, newCard)
            XCTAssertEqual(decklist[1].quantity, 1)
        }
    }
}


private extension DecklistTests {
    enum MockCard: CaseIterable {
        case spell
        case weapon
        case hero
        case minion
        case minionDupe
        
        var file: SampleFile {
            switch  self {
            case .spell: return .cardSpell
            case .weapon: return .cardWeapon
            case .hero: return .cardHeroPlayable
            case .minion: return .cardMinion
            case .minionDupe: return .cardMinion
            }
        }
    }
    
    func makeDecklist() throws -> Decklist {
        return try Decklist(cards: MockCard.allCases.map({ (card) -> Card in
            try makeCard(card)
        }))
    }
    
    func makeCard(_ card: MockCard) throws -> Card {
        let decoder = JSONDecoder()
        let file = openSampleFile(card.file)
        return try decoder.decode(Card.self, from: file)
    }
}
