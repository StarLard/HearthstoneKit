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
    // MARK: Cards
    
    func testGetCard() {
        let valueExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        let slug = "52119-arch-villain-rafaam"
        let subscriber = HearthstoneAPI.card(for: .enUS, idOrSlug: slug).sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                completeExpectation.fulfill()
            }
        }) { (card) in
            XCTAssertEqual(card.slug, slug)
            valueExpectation.fulfill()
        }
        wait(for: [valueExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        subscriber.cancel()
    }
    
    func testConstructedCardSearch() {
        let valueExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        let subscriber = HearthstoneAPI.searchConstructedCards(for: .enUS, setSlug: "rise-of-shadows", classSlug: "mage", manaCost: [10],
                                                    attack: [4], health: [10], collectible: true, raritySlug: "legendary", typeSlug: "minion",
                                                    minionTypeSlug: "dragon", keywordSlug: "battlecry", textFilter: "kalecgos",
                                                    page: 1, pageSize: 5, sort: .name, order: .descending)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    completeExpectation.fulfill()
                }
            }) { (searchResult) in
                XCTAssertEqual(searchResult.cardCount, 1)
                XCTAssertEqual(searchResult.page, 1)
                XCTAssertEqual(searchResult.pageCount, 1)
                XCTAssertEqual(searchResult.cards.first?.slug, "53002-kalecgos")
                valueExpectation.fulfill()
        }
        wait(for: [valueExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        subscriber.cancel()
    }
    
    func testBattlegroundsCardSearch() {
        let valueExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        let subscriber = HearthstoneAPI.searchBattlegroundsCards(for: .enUS, textFilter: "Alexstrasza", tiers: [.hero, .three],
                                                                 page: 1, pageSize: 5, sort: .name, order: .descending)
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    completeExpectation.fulfill()
                }
            }) { (searchResult) in
                XCTAssertEqual(searchResult.cardCount, 1)
                XCTAssertEqual(searchResult.page, 1)
                XCTAssertEqual(searchResult.pageCount, 1)
                XCTAssertEqual(searchResult.cards.first?.slug, "61488-alexstrasza")
                valueExpectation.fulfill()
        }
        wait(for: [valueExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        subscriber.cancel()
    }
    
    // MARK: Card Backs
    
    func testGetCardBack() {
        let valueExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        let slug = "155-pizza-stone"
        let subscriber = HearthstoneAPI.cardBack(for: .enUS, idOrSlug: slug).sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                completeExpectation.fulfill()
            }
        }) { (cardBack) in
            XCTAssertEqual(cardBack.slug, slug)
            valueExpectation.fulfill()
        }
        wait(for: [valueExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        subscriber.cancel()
    }
    
    func testCardBackSearch() {
        let valueExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        let subscriber = HearthstoneAPI.searchCardBacks(for: .enUS, textFilter: "The only card back you'll ever need.",
                                                        sort: .name, order: .ascending).sink(receiveCompletion: { (result) in
                switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .finished:
                    completeExpectation.fulfill()
                }
            }) { (searchResult) in
                XCTAssertEqual(searchResult.cardCount, 1)
                XCTAssertEqual(searchResult.page, 1)
                XCTAssertEqual(searchResult.pageCount, 1)
                XCTAssertEqual(searchResult.cardBacks.first?.slug, "0-classic")
                valueExpectation.fulfill()
        }
        wait(for: [valueExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        subscriber.cancel()
    }
    
    // MARK: Decks
    
    func testGetDeck() {
        let valueExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        let subscriber = HearthstoneAPI
            .deck(for: .enUS, deckcode: "AAECAQcG+wyd8AKS+AKggAOblAPanQMMS6IE/web8wLR9QKD+wKe+wKz/AL1gAOXlAOalAOSnwMA")
            .sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                completeExpectation.fulfill()
            }
        }) { (deck) in
            XCTAssertEqual(deck.class.slug, "warrior")
            XCTAssertEqual(deck.heroPower.slug, "725-armor-up")
            XCTAssertEqual(deck.hero.slug, "7-garrosh-hellscream")
            XCTAssertTrue(deck.cards.contains(where: { (slot) -> Bool in slot.quantity == 1 && slot.card.slug == "1659-acolyte-of-pain" }))
            valueExpectation.fulfill()
        }
        wait(for: [valueExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        subscriber.cancel()
    }
    
    // MARK: Metadata
}
