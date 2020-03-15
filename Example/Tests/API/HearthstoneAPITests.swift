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
        let subscriber = HearthstoneAPI.card(for: .enUS, slug: "52119-arch-villain-rafaam").sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                completeExpectation.fulfill()
            }
        }) { (card) in
            XCTAssertEqual(card.slug, "52119-arch-villain-rafaam")
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
    // MARK: Decks
    // MARK: Metadata
}
