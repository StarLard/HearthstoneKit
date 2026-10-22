//
//  MetadataTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

struct MetadataTests {
    @Test func `Player class decodes from valid data`() throws {
        let model = try JSONDecoder().decode(PlayerClass.self, from: openSampleFile(.playerClass))
        #expect(model.id == 3)
        #expect(model.slug == "hunter")
        #expect(model.name == "Hunter")
        #expect(model.kind == .hunter)
        #expect(model.cardID == 31)
    }

    @Test func `Expansion set decodes from valid data`() throws {
        let model = try JSONDecoder().decode(ExpansionSet.self, from: openSampleFile(.expansionSet))
        #expect(model.id == 1403)
        #expect(model.slug == "galakronds-awakening")
        #expect(model.name == "Galakrond's Awakening")
        #expect(model.releaseDate == Date(timeIntervalSince1970: 1577858400))
        #expect(model.type == "adventure")
        #expect(model.collectibleCount == 35)
        #expect(model.collectibleRevealedCount == 35)
        #expect(model.nonCollectibleCount == 246)
        #expect(model.nonCollectibleRevealedCount == 43)
    }

    @Test func `Expansion set group decodes from valid data`() throws {
        let model = try JSONDecoder().decode(ExpansionSet.Group.self, from: openSampleFile(.expansionSetGroup))
        #expect(model.year == 2019)
        #expect(model.slug == "dragon")
        #expect(model.name == "Year of the Dragon")
        #expect(model.isStandard == true)
        #expect(model.icon == "icon_cardset_yearofthedragon")
        #expect(model.cardSets == [
          "galakronds-awakening",
          "descent-of-dragons",
          "saviors-of-uldum",
          "rise-of-shadows"
        ])
    }

    @Test func `Game mode decodes from valid data`() throws {
        let model = try JSONDecoder().decode(GameMode.self, from: openSampleFile(.gameMode))
        #expect(model.id == 1)
        #expect(model.slug == "constructed")
        #expect(model.name == "Standard & Wild Formats")
        #expect(model.kind == .constructed)
    }

    @Test func `Minion type decodes from valid data`() throws {
        let model = try JSONDecoder().decode(MinionType.self, from: openSampleFile(.minionType))
        #expect(model.id == 14)
        #expect(model.slug == "murloc")
        #expect(model.name == "Murloc")
        #expect(model.kind == .murloc)
    }

    @Test func `Rarity decodes from valid data`() throws {
        let model = try JSONDecoder().decode(Rarity.self, from: openSampleFile(.rarity))
        #expect(model.id == 5)
        #expect(model.slug == "legendary")
        #expect(model.name == "Legendary")
        #expect(model.craftingCost.regular == 1600)
        #expect(model.craftingCost.golden == 3200)
        #expect(model.dustValue.regular == 400)
        #expect(model.dustValue.golden == 1600)
    }
}
