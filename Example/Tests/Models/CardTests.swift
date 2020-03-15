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
    func testDecodeSpellFromValidData() {
        let data = openSampleFile(.cardSpell)
        assertDoesNotThrow(try JSONDecoder().decode(Card.self, from: data)) { (card) in
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
            XCTAssertEqual(card.attack, nil)
            XCTAssertEqual(card.health, nil)
            XCTAssertEqual(card.durability, nil)
            XCTAssertEqual(card.armor, nil)
            XCTAssertEqual(card.name, "Innervate")
            XCTAssertEqual(card.attributedText?.string, "Gain 1 Mana Crystal this turn only.")
            XCTAssertEqual(card.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/2d48c3d181e4fd258dfc3c3f06ca64f2adb633cc25b301fbbf625c8e92c1ffec.png")!)
            XCTAssertEqual(card.imageGold, nil)
            XCTAssertEqual(card.flavorText, "Some druids still have flashbacks from strangers yelling \"Innervate me!!\" at them.")
            XCTAssertEqual(card.cropImage, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/603c6da3133b0bfcdc267898cabda4167402e4c8ca7a4ab43d7c1e5466a7ebf8.jpg"))
            XCTAssertEqual(card.keywordIDs, nil)
            XCTAssertEqual(card.parentID?.rawValue, nil)
            XCTAssertEqual(card.childIDs?.map({$0.rawValue}), nil)
        }
    }
    
    func testDecodeMinionFromValidData() {
        let data = openSampleFile(.cardMinion)
        assertDoesNotThrow(try JSONDecoder().decode(Card.self, from: data)) { (card) in
            XCTAssertEqual(card.id.rawValue, 52119)
            XCTAssertTrue(card.isCollectible)
            XCTAssertEqual(card.slug, "52119-arch-villain-rafaam")
            XCTAssertEqual(card.classID.rawValue, 9)
            XCTAssertEqual(card.multiClassIDs, [])
            XCTAssertEqual(card.cardTypeID.rawValue, 4)
            XCTAssertEqual(card.cardSetID.rawValue, 1130)
            XCTAssertEqual(card.rarityID.rawValue, 5)
            XCTAssertEqual(card.artistName, "Alex Horley Orlandelli")
            XCTAssertEqual(card.manaCost, 7)
            XCTAssertEqual(card.attack, 7)
            XCTAssertEqual(card.health, 8)
            XCTAssertEqual(card.durability, nil)
            XCTAssertEqual(card.armor, nil)
            XCTAssertEqual(card.name, "Arch-Villain Rafaam")
            XCTAssertEqual(card.attributedText?.string, "Taunt Battlecry: Replace your hand and deck with Legendary minions.")
            XCTAssertEqual(card.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/56c8b21f56380e726255287ff4ce9fd4f50041cdbc1f246009f6288a8d8287ad.png")!)
            XCTAssertEqual(card.imageGold, nil)
            XCTAssertEqual(card.flavorText, "Minions must wash hands before being LIQUIDATED AND REPLACED BY SOMEONE BETTER.")
            XCTAssertEqual(card.cropImage, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/88803effaa821c7d76f5f0c3b1fd044ba62a884dcc207cb318d32583986fe9a6.jpg"))
            XCTAssertEqual(card.keywordIDs?.map({$0.rawValue}), [1, 8])
            XCTAssertEqual(card.parentID?.rawValue, nil)
            XCTAssertEqual(card.childIDs?.map({$0.rawValue}), nil)
        }
    }
    
    func testDecodeWeaponFromValidData() {
        let data = openSampleFile(.cardWeapon)
        assertDoesNotThrow(try JSONDecoder().decode(Card.self, from: data)) { (card) in
            XCTAssertEqual(card.id.rawValue, 46107)
            XCTAssertTrue(card.isCollectible)
            XCTAssertEqual(card.slug, "46107-twig-of-the-world-tree")
            XCTAssertEqual(card.classID.rawValue, 2)
            XCTAssertEqual(card.multiClassIDs, [])
            XCTAssertEqual(card.cardTypeID.rawValue, 7)
            XCTAssertEqual(card.cardSetID.rawValue, 1004)
            XCTAssertEqual(card.rarityID.rawValue, 5)
            XCTAssertEqual(card.artistName, "Alexey Aparin")
            XCTAssertEqual(card.attack, 1)
            XCTAssertEqual(card.manaCost, 4)
            XCTAssertEqual(card.health, nil)
            XCTAssertEqual(card.durability, 5)
            XCTAssertEqual(card.armor, nil)
            XCTAssertEqual(card.name, "Twig of the World Tree")
            XCTAssertEqual(card.attributedText?.string, "Deathrattle: Gain 10 Mana Crystals.")
            XCTAssertEqual(card.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/22a9c58833289e5fc0a3a61ae8cd8c27b12c446db9491c875be2b082f99580a1.png")!)
            XCTAssertEqual(card.imageGold, nil)
            XCTAssertEqual(card.flavorText, "For druids who want to branch out.")
            XCTAssertEqual(card.cropImage, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/c2145cc616bf539204369d054b830903d09c2dba6a936c490449efc9ec13a05d.jpg"))
            XCTAssertEqual(card.keywordIDs?.map({$0.rawValue}), [12])
            XCTAssertEqual(card.parentID?.rawValue, nil)
            XCTAssertEqual(card.childIDs?.map({$0.rawValue}), nil)
        }
    }
    
    func testDecodeHeroSkinFromValidData() {
        let data = openSampleFile(.cardHeroSkin)
        assertDoesNotThrow(try JSONDecoder().decode(Card.self, from: data)) { (card) in
            XCTAssertEqual(card.id.rawValue, 39117)
            XCTAssertTrue(card.isCollectible)
            XCTAssertEqual(card.slug, "39117-khadgar")
            XCTAssertEqual(card.classID.rawValue, 4)
            XCTAssertEqual(card.multiClassIDs, [])
            XCTAssertEqual(card.cardTypeID.rawValue, 3)
            XCTAssertEqual(card.cardSetID.rawValue, 17)
            XCTAssertEqual(card.rarityID.rawValue, 4)
            XCTAssertEqual(card.artistName, nil)
            XCTAssertEqual(card.manaCost, 0)
            XCTAssertEqual(card.attack, nil)
            XCTAssertEqual(card.health, 30)
            XCTAssertEqual(card.armor, nil)
            XCTAssertEqual(card.durability, nil)
            XCTAssertEqual(card.name, "Khadgar")
            XCTAssertEqual(card.attributedText?.string, "")
            XCTAssertEqual(card.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/aa225c96ba982a1eab4c27033015ab3af79a338fb48e09898d591e80e28a2c5c.png")!)
            XCTAssertEqual(card.imageGold, nil)
            XCTAssertEqual(card.flavorText, "")
            XCTAssertEqual(card.cropImage, nil)
            XCTAssertEqual(card.keywordIDs?.map({$0.rawValue}), nil)
            XCTAssertEqual(card.parentID?.rawValue, 637)
            XCTAssertEqual(card.childIDs?.map({$0.rawValue}), [39791])
        }
    }
    
    func testDecodeHeroCardFromValidData() {
        let data = openSampleFile(.cardHeroPlayable)
        assertDoesNotThrow(try JSONDecoder().decode(Card.self, from: data)) { (card) in
            XCTAssertEqual(card.id.rawValue, 43406)
            XCTAssertTrue(card.isCollectible)
            XCTAssertEqual(card.slug, "43406-uther-of-the-ebon-blade")
            XCTAssertEqual(card.classID.rawValue, 5)
            XCTAssertEqual(card.multiClassIDs, [])
            XCTAssertEqual(card.cardTypeID.rawValue, 3)
            XCTAssertEqual(card.cardSetID.rawValue, 1001)
            XCTAssertEqual(card.rarityID.rawValue, 5)
            XCTAssertEqual(card.artistName, "James Ryman")
            XCTAssertEqual(card.manaCost, 9)
            XCTAssertEqual(card.attack, nil)
            XCTAssertEqual(card.health, 30)
            XCTAssertEqual(card.armor, 5)
            XCTAssertEqual(card.durability, nil)
            XCTAssertEqual(card.name, "Uther of the Ebon Blade")
            XCTAssertEqual(card.attributedText?.string, "Battlecry: Equip a 5/3 Lifesteal weapon.")
            XCTAssertEqual(card.image, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/3d140b58399f20b6e7e3ad05b562975820a6702f6beb3fee040f1baf2f3a7a14.png")!)
            XCTAssertEqual(card.imageGold, nil)
            XCTAssertEqual(card.flavorText, "\"Step forward. Confess! Once I was a mere servant of the Light. Now I alone stand in judgement.\"")
            XCTAssertEqual(card.cropImage, URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/de37186287a73f6a463b6de0254f8f61aa65b22015b9b821546fb240274f6b80.jpg")!)
            XCTAssertEqual(card.keywordIDs?.map({$0.rawValue}), [8, 38])
            XCTAssertEqual(card.parentID?.rawValue, nil)
            XCTAssertEqual(card.childIDs?.map({$0.rawValue}), [43013, 43405])
        }
    }
    
    func testDecodeCardTypeFromValidData() {
        let data = openSampleFile(.cardType)
        assertDoesNotThrow(try JSONDecoder().decode(Card.CardType.self, from: data)) { (cardType) in
            XCTAssertEqual(cardType.id.rawValue, 3)
            XCTAssertEqual(cardType.slug, "hero")
            XCTAssertEqual(cardType.name, "Hero")
            XCTAssertEqual(cardType.kind, .hero)
        }
    }
    
    func testDecodeCardKeyworkFromValidData() {
        let data = openSampleFile(.cardKeyword)
        assertDoesNotThrow(try JSONDecoder().decode(Card.Keyword.self, from: data)) { (keyword) in
            XCTAssertEqual(keyword.id.rawValue, 3)
            XCTAssertEqual(keyword.slug, "divine-shield")
            XCTAssertEqual(keyword.name, "Divine Shield")
            XCTAssertEqual(keyword.text, "The first time this minion takes damage, ignore it.")
            XCTAssertEqual(keyword.referenceText, "The first time a Shielded minion takes damage, ignore it.")
        }
    }
}
