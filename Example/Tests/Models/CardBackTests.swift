//
//  CardBackTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class CardBackTests: HSKitTestCase {
    func testDecodeCardBackFromValidData() throws {
        let data = openSampleFile(.cardBack)
        assertDoesNotThrow(try JSONDecoder().decode(CardBack.self, from: data)) { (cardBack) in
            XCTAssertEqual(cardBack.id.rawValue, 155)
            XCTAssertEqual(cardBack.slug, "155-pizza-stone")
            XCTAssertEqual(cardBack.sortCategoryID.rawValue, 5)
            XCTAssertEqual(cardBack.name, "Pizza Stone")
            XCTAssertEqual(cardBack.text, "For when you want to build a deck with extra cheese.\\n\\nAcquired from winning five games in Ranked Play, February 2019.")
            XCTAssertEqual(cardBack.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/2f831a00ef1f7671b8132b8c1b0cd63c1ebb7ad334d8903d59f6bd4f60469ccd.png")!)
        }
    }
    
    func testDecodeCardBackCategoryFromValidData() throws {
        let data = openSampleFile(.cardBackCategory)
        assertDoesNotThrow(try JSONDecoder().decode(CardBack.SortCategory.self, from: data)) { (cardBackSortCategory) in
            XCTAssertEqual(cardBackSortCategory.id.rawValue, 1)
            XCTAssertEqual(cardBackSortCategory.slug, "base")
            XCTAssertEqual(cardBackSortCategory.name, "Basic")
        }
    }
}
