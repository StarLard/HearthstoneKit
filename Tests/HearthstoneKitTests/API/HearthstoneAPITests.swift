//
//  HearthstoneAPITests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 3/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Testing
@testable import HearthstoneKit

extension LiveAPITests {
    @Suite struct HearthstoneAPITests {
        init() async throws {
            try await configureSDKIfNeeded()
        }

        // MARK: Cards

        @Test func `Get card`() async throws {
            let slug = "52119-arch-villain-rafaam"
            let card = try await HearthstoneAPI.getCard(for: .enUS, idOrSlug: slug)
            #expect(card.slug == slug)
        }

        @Test func `Constructed card search`() async throws {
            // No `keywordSlug`: Blizzard's keyword slugs currently end in a newline (e.g. "battlecry\n"), so `keyword=battlecry` matches nothing.
            let searchResult = try await HearthstoneAPI.searchConstructedCards(for: .enUS, setSlug: "rise-of-shadows", classSlug: "mage", manaCost: [8],
                                                                               attack: [4], health: [12], collectible: true, raritySlug: "legendary",
                                                                               typeSlug: "minion", minionTypeSlug: "dragon",
                                                                               textFilter: "kalecgos", page: 1, pageSize: 5, sort: .name, order: .descending)
            #expect(searchResult.cardCount == 1)
            #expect(searchResult.page == 1)
            #expect(searchResult.pageCount == 1)
            #expect(searchResult.cards.first?.slug == "53002-kalecgos")
        }

        @Test func `Battlegrounds card search`() async throws {
            // Filters by type rather than `tiers: [.hero]`: the live API currently returns no cards for `tier=hero`, despite the docs listing it.
            let searchResult = try await HearthstoneAPI.searchBattlegroundsCards(for: .enUS, typeSlug: "hero", textFilter: "Alexstrasza",
                                                                                 page: 1, pageSize: 5, sort: .name, order: .descending)
            #expect(searchResult.cardCount == 1)
            #expect(searchResult.page == 1)
            #expect(searchResult.pageCount == 1)
            #expect(searchResult.cards.first?.slug == "61488-alexstrasza")
        }

        @Test func `Spell school search`() async throws {
            let fireSpells = try await HearthstoneAPI.searchConstructedCards(for: .enUS, spellSchoolSlug: "fire", pageSize: 1)
            let allCards = try await HearthstoneAPI.searchConstructedCards(for: .enUS, pageSize: 1)
            #expect(fireSpells.cardCount > 0)
            #expect(fireSpells.cardCount < allCards.cardCount)
        }

        @Test func `Mercenaries card search`() async throws {
            let searchResult = try await HearthstoneAPI.searchMercenariesCards(for: .enUS, mercenaryIDs: [23], mercenaryRoleSlugs: ["tank"],
                                                                               isDefaultMercenary: true)
            #expect(searchResult.cardCount == 1)
            #expect(searchResult.cards.first?.slug == "64590-alexstrasza")
        }

        @Test func `Every Mercenaries card decodes`() async throws {
            let searchResult = try await HearthstoneAPI.searchMercenariesCards(for: .enUS, pageSize: 500)
            #expect(searchResult.pageCount == 1)
            #expect(searchResult.cards.count == searchResult.cardCount)
        }

        @Test func `Get all cards`() async throws {
            let searchResult = try await HearthstoneAPI.searchConstructedCards(for: .enUS, pageSize: 500)
            #expect(searchResult.cardCount >= 2377)
            #expect(searchResult.pageCount >= 5)
            #expect(searchResult.page == 1)
            #expect(searchResult.cards.count == 500)
        }

        // MARK: Card Backs

        @Test func `Get card back`() async throws {
            let slug = "155-pizza-stone"
            let cardBack = try await HearthstoneAPI.getCardBack(for: .enUS, idOrSlug: slug)
            #expect(cardBack.slug == slug)
        }

        @Test func `Card back search`() async throws {
            let searchResult = try await HearthstoneAPI.searchCardBacks(for: .enUS, textFilter: "The only card back you'll ever need.",
                                                                      sort: .name, order: .ascending)
            #expect(searchResult.cardCount == 1)
            #expect(searchResult.page == 1)
            #expect(searchResult.pageCount == 1)
            #expect(searchResult.cardBacks.first?.slug == "0-classic")
        }

        @Test func `Card back search pages results`() async throws {
            let searchResult = try await HearthstoneAPI.searchCardBacks(for: .enUS, page: 2, pageSize: 2)
            #expect(searchResult.page == 2)
            #expect(searchResult.cardBacks.count == 2)
            #expect(searchResult.pageCount > 2)
        }

        // MARK: Decks

        @Test func `Get deck`() async throws {
            let deck = try await HearthstoneAPI.getDeck(for: .enUS, deckcode: "AAECAQcG+wyd8AKS+AKggAOblAPanQMMS6IE/web8wLR9QKD+wKe+wKz/AL1gAOXlAOalAOSnwMA")
            #expect(deck.class.slug == "warrior")
            #expect(deck.heroPower.slug == "725-armor-up")
            #expect(deck.hero.slug == "7-garrosh-hellscream")
            #expect(deck.decklist.contains(where: { (slot) -> Bool in slot.quantity == 1 && slot.card.slug == "1659-acolyte-of-pain" }))
        }

        // MARK: Metadata

        @Test func `Get metadata`() async throws {
            let rarities = try await HearthstoneAPI.getMetadata(for: .enUS, metadataType: Rarity.self)
            #expect(rarities.contains(where: { (rarity) -> Bool in rarity.slug == "common" }))
        }

        @Test func `Get spell school metadata`() async throws {
            let spellSchools = try await HearthstoneAPI.getMetadata(for: .enUS, metadataType: SpellSchool.self)
            #expect(spellSchools.contains(where: { (spellSchool) -> Bool in spellSchool.slug == "fire" }))
        }

        @Test func `Get mercenary role metadata`() async throws {
            let roles = try await HearthstoneAPI.getMetadata(for: .enUS, metadataType: MercenaryRole.self)
            #expect(roles.contains(where: { (role) -> Bool in role.slug == "tank" }))
        }

        @Test func `Get all metadata`() async throws {
            let metadata = try await HearthstoneAPI.getAllMetadata(for: .enUS)
            #expect(metadata.rarities.contains(where: { (rarity) -> Bool in rarity.slug == "common" }))
            #expect(metadata.sets.contains(where: { (set) -> Bool in set.slug == "the-witchwood" }))
        }
    }
}

