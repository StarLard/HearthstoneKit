//
//  MetadataTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class MetadataTests: HSKitTestCase {
    func testPlayerClassDecodeFromValidData() throws {
        let data = openSampleFile(.playerClass)
        let model = try JSONDecoder().decode(PlayerClass.self, from: data)
        XCTAssertEqual(model.id.rawValue, 3)
        XCTAssertEqual(model.slug, "hunter")
        XCTAssertEqual(model.name, "Hunter")
        XCTAssertEqual(model.kind, .hunter)
        XCTAssertEqual(model.cardID?.rawValue, 31)
    }
    
    func testExpansionSetDecodeFromValidData() throws {
        let data = openSampleFile(.expansionSet)
        let model = try JSONDecoder().decode(ExpansionSet.self, from: data)
        XCTAssertEqual(model.id.rawValue, 1403)
        XCTAssertEqual(model.slug, "galakronds-awakening")
        XCTAssertEqual(model.name, "Galakrond's Awakening")
        XCTAssertEqual(model.releaseDate, Date(timeIntervalSince1970: 1577858400))
        XCTAssertEqual(model.type, "adventure")
        XCTAssertEqual(model.collectibleCount, 35)
        XCTAssertEqual(model.collectibleRevealedCount, 35)
        XCTAssertEqual(model.nonCollectibleCount, 246)
        XCTAssertEqual(model.nonCollectibleRevealedCount, 43)
    }
    
    func testExpansionSetGroupDecodeFromValidData() throws {
        let data = openSampleFile(.expansionSetGroup)
        let model = try JSONDecoder().decode(ExpansionSetGroup.self, from: data)
        XCTAssertEqual(model.year, 2019)
        XCTAssertEqual(model.slug, "dragon")
        XCTAssertEqual(model.name, "Year of the Dragon")
        XCTAssertEqual(model.isStandard, true)
        XCTAssertEqual(model.icon, "icon_cardset_yearofthedragon")
        XCTAssertEqual(model.cardSets, [
          "galakronds-awakening",
          "descent-of-dragons",
          "saviors-of-uldum",
          "rise-of-shadows"
        ])
    }
    
    func testGameModeDecodeFromValidData() throws {
        let data = openSampleFile(.gameMode)
        let model = try JSONDecoder().decode(GameMode.self, from: data)
        XCTAssertEqual(model.id.rawValue, 1)
        XCTAssertEqual(model.slug, "constructed")
        XCTAssertEqual(model.name, "Standard & Wild Formats")
        XCTAssertEqual(model.kind, .constructed)
    }
    
    func testMinionTypeDecodeFromValidData() throws {
        let data = openSampleFile(.minionType)
        let model = try JSONDecoder().decode(MinionType.self, from: data)
        XCTAssertEqual(model.id.rawValue, 14)
        XCTAssertEqual(model.slug, "murloc")
        XCTAssertEqual(model.name, "Murloc")
        XCTAssertEqual(model.kind, .murloc)
    }
    
    func testRarityDecodeFromValidData() throws {
        let data = openSampleFile(.rarity)
        let model = try JSONDecoder().decode(Rarity.self, from: data)
        XCTAssertEqual(model.id.rawValue, 5)
        XCTAssertEqual(model.slug, "legendary")
        XCTAssertEqual(model.name, "Legendary")
        XCTAssertEqual(model.craftingCost.regular, 1600)
        XCTAssertEqual(model.craftingCost.golden, 3200)
        XCTAssertEqual(model.dustValue.regular, 400)
        XCTAssertEqual(model.dustValue.golden, 1600)

    }
}
