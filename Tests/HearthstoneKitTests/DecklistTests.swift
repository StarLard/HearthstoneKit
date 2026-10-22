//
//  DecklistTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/22/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

struct DecklistTests {
    /// Each step builds on the decklist state left by the previous one, so this stays a single test.
    @Test func `Decklist flows`() throws {
        var decklist = try makeDecklist()
        let newCard = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardHeroSkin))
        let spell = try makeCard(.spell)
        let weapon = try makeCard(.weapon)
        let minion = try makeCard(.minion)
        let hero = try makeCard(.hero)
        // `#expect` can't wrap mutating calls, so their results are captured here first.
        var didChange: Bool

        // Init creates sorted deck
        #expect(decklist.numberOfCards == 5)
        #expect(decklist.numberOfSlots == 4)
        #expect(decklist[0].card == spell)
        #expect(decklist[0].quantity == 1)
        #expect(decklist[1].card == weapon)
        #expect(decklist[1].quantity == 1)
        #expect(decklist[2].card == minion)
        #expect(decklist[2].quantity == 2)
        #expect(decklist[3].card == hero)
        #expect(decklist[3].quantity == 1)
        #expect(decklist.cards == [spell, weapon, minion, minion, hero])

        // Binary search finds cards
        #expect(decklist.contains(spell) == 0)
        #expect(decklist.contains(weapon) == 1)
        #expect(decklist.contains(minion) == 2)
        #expect(decklist.contains(hero) == 3)
        #expect(decklist.contains(newCard) == nil)

        // Decrementing card not in the decklist does nothing
        didChange = decklist.decrementCard(newCard)
        #expect(!didChange)
        #expect(decklist.numberOfCards == 5)
        #expect(decklist.numberOfSlots == 4)

        // Incrementing an existing card increases quantity
        didChange = decklist.incrementCard(spell)
        #expect(didChange)
        #expect(decklist.numberOfCards == 6)
        #expect(decklist.numberOfSlots == 4)
        #expect(decklist[0].card == spell)
        #expect(decklist[0].quantity == 2)

        // Incrementing limits are enforced
        didChange = decklist.incrementCard(spell)
        #expect(!didChange)
        #expect(decklist.numberOfCards == 6)
        #expect(decklist.numberOfSlots == 4)
        #expect(decklist[0].card == spell)
        #expect(decklist[0].quantity == 2)

        didChange = decklist.incrementCard(spell, slotLimit: 3)

        #expect(didChange)
        #expect(decklist.numberOfCards == 7)
        #expect(decklist.numberOfSlots == 4)
        #expect(decklist[0].card == spell)
        #expect(decklist[0].quantity == 3)

        // Decrementing an existing card decreases quantity
        didChange = decklist.decrementCard(spell)
        #expect(didChange)
        #expect(decklist.numberOfCards == 6)
        #expect(decklist.numberOfSlots == 4)
        #expect(decklist.contains(spell) == 0)
        #expect(decklist[0].card == spell)
        #expect(decklist[0].quantity == 2)

        didChange = decklist.decrementCard(weapon)

        #expect(didChange)
        #expect(decklist.numberOfCards == 5)
        #expect(decklist.numberOfSlots == 3)
        #expect(decklist.contains(weapon) == nil)
        #expect(decklist[1].card == minion)
        #expect(decklist[1].quantity == 2)

        // Incrementing a new card increases quantity
        didChange = decklist.incrementCard(newCard)
        #expect(didChange)
        #expect(decklist.numberOfCards == 6)
        #expect(decklist.numberOfSlots == 4)
        #expect(decklist.contains(newCard) == 1)
        #expect(decklist[1].card == newCard)
        #expect(decklist[1].quantity == 1)
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
        let file = try openSampleFile(card.file)
        return try decoder.decode(Card.self, from: file)
    }
}
