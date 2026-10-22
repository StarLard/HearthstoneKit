//
//  CardBackTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

struct CardBackTests {
    @Test func `Decode card back from valid data`() throws {
        let cardBack = try JSONDecoder().decode(CardBack.self, from: openSampleFile(.cardBack))
        #expect(cardBack.id == 155)
        #expect(cardBack.slug == "155-pizza-stone")
        #expect(cardBack.sortCategoryID == 5)
        #expect(cardBack.name == "Pizza Stone")
        #expect(cardBack.text == "For when you want to build a deck with extra cheese.\\n\\nAcquired from winning five games in Ranked Play, February 2019.")
        #expect(cardBack.image == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/2f831a00ef1f7671b8132b8c1b0cd63c1ebb7ad334d8903d59f6bd4f60469ccd.png"))
    }

    @Test func `Decode card back category from valid data`() throws {
        let cardBackSortCategory = try JSONDecoder().decode(CardBack.SortCategory.self, from: openSampleFile(.cardBackCategory))
        #expect(cardBackSortCategory.id == 1)
        #expect(cardBackSortCategory.slug == "base")
        #expect(cardBackSortCategory.name == "Basic")
    }
}
