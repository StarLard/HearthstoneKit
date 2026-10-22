//
//  CardTests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

struct CardTests {
    @Test func `Decode spell from valid data`() throws {
        let card = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardSpell))
        #expect(card.id == 254)
        #expect(card.isCollectible)
        #expect(card.slug == "254-innervate")
        #expect(card.classID == 2)
        #expect(card.multiClassIDs == [])
        #expect(card.cardTypeID == 5)
        #expect(card.cardSetID == 2)
        #expect(card.rarityID == 2)
        #expect(card.artistName == "Doug Alexander")
        #expect(card.manaCost == 0)
        #expect(card.attack == nil)
        #expect(card.health == nil)
        #expect(card.durability == nil)
        #expect(card.armor == nil)
        #expect(card.name == "Innervate")
        #expect(card.attributedText.map(\.characters).map(String.init(_:)) == "Gain 1 Mana Crystal this turn only.")
        #expect(card.image == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/2d48c3d181e4fd258dfc3c3f06ca64f2adb633cc25b301fbbf625c8e92c1ffec.png"))
        #expect(card.imageGold == nil)
        #expect(card.flavorText == "Some druids still have flashbacks from strangers yelling \"Innervate me!!\" at them.")
        #expect(card.cropImage == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/603c6da3133b0bfcdc267898cabda4167402e4c8ca7a4ab43d7c1e5466a7ebf8.jpg"))
        #expect(card.keywordIDs == nil)
        #expect(card.parentID?.rawValue == nil)
        #expect(card.childIDs?.map({$0.rawValue}) == nil)
    }
    
    @Test func `Decode minion from valid data`() throws {
        let card = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardMinion))
        #expect(card.id == 52119)
        #expect(card.isCollectible)
        #expect(card.slug == "52119-arch-villain-rafaam")
        #expect(card.classID == 9)
        #expect(card.multiClassIDs == [])
        #expect(card.cardTypeID == 4)
        #expect(card.cardSetID == 1130)
        #expect(card.rarityID == 5)
        #expect(card.artistName == "Alex Horley Orlandelli")
        #expect(card.manaCost == 7)
        #expect(card.attack == 7)
        #expect(card.health == 8)
        #expect(card.durability == nil)
        #expect(card.armor == nil)
        #expect(card.name == "Arch-Villain Rafaam")
        #expect(card.attributedText.map(\.characters).map(String.init(_:)) == "Taunt Battlecry: Replace your hand and deck with Legendary minions.")
        #expect(card.image == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/56c8b21f56380e726255287ff4ce9fd4f50041cdbc1f246009f6288a8d8287ad.png"))
        #expect(card.imageGold == nil)
        #expect(card.flavorText == "Minions must wash hands before being LIQUIDATED AND REPLACED BY SOMEONE BETTER.")
        #expect(card.cropImage == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/88803effaa821c7d76f5f0c3b1fd044ba62a884dcc207cb318d32583986fe9a6.jpg"))
        #expect(card.keywordIDs == [1, 8])
        #expect(card.parentID?.rawValue == nil)
        #expect(card.childIDs == nil)
    }
    
    @Test func `Decode weapon from valid data`() throws {
        let card = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardWeapon))
        #expect(card.id == 46107)
        #expect(card.isCollectible)
        #expect(card.slug == "46107-twig-of-the-world-tree")
        #expect(card.classID == 2)
        #expect(card.multiClassIDs == [])
        #expect(card.cardTypeID == 7)
        #expect(card.cardSetID == 1004)
        #expect(card.rarityID == 5)
        #expect(card.artistName == "Alexey Aparin")
        #expect(card.attack == 1)
        #expect(card.manaCost == 4)
        #expect(card.health == nil)
        #expect(card.durability == 5)
        #expect(card.armor == nil)
        #expect(card.name == "Twig of the World Tree")
        #expect(card.attributedText.map(\.characters).map(String.init(_:)) == "Deathrattle: Gain 10 Mana Crystals.")
        #expect(card.image == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/22a9c58833289e5fc0a3a61ae8cd8c27b12c446db9491c875be2b082f99580a1.png"))
        #expect(card.imageGold == nil)
        #expect(card.flavorText == "For druids who want to branch out.")
        #expect(card.cropImage == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/c2145cc616bf539204369d054b830903d09c2dba6a936c490449efc9ec13a05d.jpg"))
        #expect(card.keywordIDs == [12])
        #expect(card.parentID == nil)
        #expect(card.childIDs == nil)
    }
    
    @Test func `Decode hero skin from valid data`() throws {
        let card = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardHeroSkin))
        #expect(card.id == 39117)
        #expect(card.isCollectible)
        #expect(card.slug == "39117-khadgar")
        #expect(card.classID == 4)
        #expect(card.multiClassIDs == [])
        #expect(card.cardTypeID == 3)
        #expect(card.cardSetID == 17)
        #expect(card.rarityID == 4)
        #expect(card.artistName == nil)
        #expect(card.manaCost == 0)
        #expect(card.attack == nil)
        #expect(card.health == 30)
        #expect(card.armor == nil)
        #expect(card.durability == nil)
        #expect(card.name == "Khadgar")
        #expect(card.attributedText.map(\.characters).map(String.init(_:)) == "")
        #expect(card.image == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/aa225c96ba982a1eab4c27033015ab3af79a338fb48e09898d591e80e28a2c5c.png"))
        #expect(card.imageGold == nil)
        #expect(card.flavorText == "")
        #expect(card.cropImage == nil)
        #expect(card.keywordIDs?.map({$0.rawValue}) == nil)
        #expect(card.parentID == 637)
        #expect(card.childIDs == [39791])
    }
    
    @Test func `Decode hero card from valid data`() throws {
        let card = try JSONDecoder().decode(Card.self, from: openSampleFile(.cardHeroPlayable))
        #expect(card.id == 43406)
        #expect(card.isCollectible)
        #expect(card.slug == "43406-uther-of-the-ebon-blade")
        #expect(card.classID == 5)
        #expect(card.multiClassIDs == [])
        #expect(card.cardTypeID == 3)
        #expect(card.cardSetID == 1001)
        #expect(card.rarityID == 5)
        #expect(card.artistName == "James Ryman")
        #expect(card.manaCost == 9)
        #expect(card.attack == nil)
        #expect(card.health == 30)
        #expect(card.armor == 5)
        #expect(card.durability == nil)
        #expect(card.name == "Uther of the Ebon Blade")
        #expect(card.attributedText.map(\.characters).map(String.init(_:)) == "Battlecry: Equip a 5/3 Lifesteal weapon.")
        #expect(card.image == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/3d140b58399f20b6e7e3ad05b562975820a6702f6beb3fee040f1baf2f3a7a14.png"))
        #expect(card.imageGold == nil)
        #expect(card.flavorText == "\"Step forward. Confess! Once I was a mere servant of the Light. Now I alone stand in judgement.\"")
        #expect(card.cropImage == URL(string: "https://d15f34w2p8l1cc.cloudfront.net/hearthstone/de37186287a73f6a463b6de0254f8f61aa65b22015b9b821546fb240274f6b80.jpg"))
        #expect(card.keywordIDs == [8, 38])
        #expect(card.parentID?.rawValue == nil)
        #expect(card.childIDs == [43013, 43405])
    }
    
    @Test func `Decode card without a class`() throws {
        // Most Mercenaries cards have a null `classId`.
        var json = try #require(try JSONSerialization.jsonObject(with: openSampleFile(.cardMinion)) as? [String: Any])
        json["classId"] = NSNull()
        let card = try JSONDecoder().decode(Card.self, from: JSONSerialization.data(withJSONObject: json))
        #expect(card.classID == nil)
        #expect(card.slug == "52119-arch-villain-rafaam")
    }

    @Test func `Decode card type from valid data`() throws {
        let cardType = try JSONDecoder().decode(Card.CardType.self, from: openSampleFile(.cardType))
        #expect(cardType.id == 3)
        #expect(cardType.slug == "hero")
        #expect(cardType.name == "Hero")
        #expect(cardType.kind == .hero)
    }
    
    @Test func `Decode card keyword from valid data`() throws {
        let keyword = try JSONDecoder().decode(Card.Keyword.self, from: openSampleFile(.cardKeyword))
        #expect(keyword.id == 3)
        #expect(keyword.slug == "divine-shield")
        #expect(keyword.name == "Divine Shield")
        #expect(keyword.text == "The first time this minion takes damage, ignore it.")
        #expect(keyword.referenceText == "The first time a Shielded minion takes damage, ignore it.")
    }
}
