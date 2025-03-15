//
//  HearthstoneAPITests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 3/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class HearthstoneAPITests: HSKitTestCase {
    static let testTimeout: TimeInterval = 5

    // MARK: Cards

    func testGetCard() async throws {
        let slug = "52119-arch-villain-rafaam"
        let card = try await HearthstoneAPI.getCard(for: .enUS, idOrSlug: slug)
        XCTAssertEqual(card.slug, slug)
    }

    func testConstructedCardSearch() async throws {
        let searchResult = try await HearthstoneAPI.searchConstructedCards(for: .enUS, setSlug: "rise-of-shadows", classSlug: "mage", manaCost: [10],
                                                                           attack: [4], health: [10], collectible: true, raritySlug: "legendary",
                                                                           typeSlug: "minion", minionTypeSlug: "dragon", keywordSlug: "battlecry",
                                                                           textFilter: "kalecgos", page: 1, pageSize: 5, sort: .name, order: .descending)
        XCTAssertEqual(searchResult.cardCount, 1)
        XCTAssertEqual(searchResult.page, 1)
        XCTAssertEqual(searchResult.pageCount, 1)
        XCTAssertEqual(searchResult.cards.first?.slug, "53002-kalecgos")
    }

    func testBattlegroundsCardSearch() async throws {
        let searchResult = try await HearthstoneAPI.searchBattlegroundsCards(for: .enUS, textFilter: "Alexstrasza", tiers: [.hero, .three],
                                                                             page: 1, pageSize: 5, sort: .name, order: .descending)
        XCTAssertEqual(searchResult.cardCount, 1)
        XCTAssertEqual(searchResult.page, 1)
        XCTAssertEqual(searchResult.pageCount, 1)
        XCTAssertEqual(searchResult.cards.first?.slug, "61488-alexstrasza")
    }

    func testGetAllCards() async throws {
        let searchResult = try await HearthstoneAPI.searchConstructedCards(for: .enUS, pageSize: 500)
        XCTAssertGreaterThanOrEqual(searchResult.cardCount, 2377)
        XCTAssertGreaterThanOrEqual(searchResult.pageCount, 5)
        XCTAssertEqual(searchResult.page, 1)
        XCTAssertEqual(searchResult.cards.count, 500)
    }

    // MARK: Card Backs

    func testGetCardBack() async throws {
        let slug = "155-pizza-stone"
        let cardBack = try await HearthstoneAPI.getCardBack(for: .enUS, idOrSlug: slug)
        XCTAssertEqual(cardBack.slug, slug)
    }

    func testCardBackSearch() async throws {
        let searchResult = try await HearthstoneAPI.searchCardBacks(for: .enUS, textFilter: "The only card back you'll ever need.",
                                                                  sort: .name, order: .ascending)
        XCTAssertEqual(searchResult.cardCount, 1)
        XCTAssertEqual(searchResult.page, 1)
        XCTAssertEqual(searchResult.pageCount, 1)
        XCTAssertEqual(searchResult.cardBacks.first?.slug, "0-classic")
    }

    // MARK: Decks

    func testGetDeck() async throws {
        let deck = try await HearthstoneAPI.getDeck(for: .enUS, deckcode: "AAECAQcG+wyd8AKS+AKggAOblAPanQMMS6IE/web8wLR9QKD+wKe+wKz/AL1gAOXlAOalAOSnwMA")
        XCTAssertEqual(deck.class.slug, "warrior")
        XCTAssertEqual(deck.heroPower.slug, "725-armor-up")
        XCTAssertEqual(deck.hero.slug, "7-garrosh-hellscream")
        XCTAssertTrue(deck.decklist.contains(where: { (slot) -> Bool in slot.quantity == 1 && slot.card.slug == "1659-acolyte-of-pain" }))
    }

    // MARK: Metadata

    func testGetMetadata() async throws {
        let rarities = try await HearthstoneAPI.getMetadata(for: .enUS, metadataType: Rarity.self)
        XCTAssertTrue(rarities.contains(where: { (rarity) -> Bool in rarity.slug == "common" }))
    }

    func testGetAllMetadata() async throws {
        let metadata = try await HearthstoneAPI.getAllMetadata(for: .enUS)
        XCTAssertTrue(metadata.rarities.contains(where: { (rarity) -> Bool in rarity.slug == "common" }))
        XCTAssertTrue(metadata.sets.contains(where: { (set) -> Bool in set.slug == "the-witchwood" }))
    }
}
