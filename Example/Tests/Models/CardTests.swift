//
//  CardTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class CardTests: HSKitTestCase {
    func testDecodeFromValidDataDoesNotThrow() {
        let data = openSampleFile(.card)
        XCTAssertNoThrow({
            let card = try JSONDecoder().decode(Card.self, from: data)
            XCTAssertEqual(card.id.rawValue, 254)
            XCTAssertTrue(card.isCollectible)
            XCTAssertEqual(card.slug, "254-innervate")
            XCTAssertEqual(card.classID.rawValue, 2)
            XCTAssertEqual(card.multiClassIDs, [])
            XCTAssertEqual(card.cardTypeID.rawValue, 5)
            XCTAssertEqual(card.cardSetID.rawValue, 2)
            XCTAssertEqual(card.rarityID.rawValue, 2)
            XCTAssertEqual(card.artistName, "Doug Alexander")
            XCTAssertEqual(card.manaCost, 0)
            XCTAssertEqual(card.name, "Innervate")
            XCTAssertEqual(card.text.string, "Gain 1 Mana Crystal this turn only.")
            XCTAssertEqual(card.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/2d48c3d181e4fd258dfc3c3f06ca64f2adb633cc25b301fbbf625c8e92c1ffec.png")!)
            XCTAssertEqual(card.imageGold, URL(string: ""))
            XCTAssertEqual(card.flavorText, "Some druids still have flashbacks from strangers yelling \"Innervate me!!\" at them.")
            XCTAssertEqual(card.cropImage, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/603c6da3133b0bfcdc267898cabda4167402e4c8ca7a4ab43d7c1e5466a7ebf8.jpg"))
        })
    }
}
