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
        let playerClass = try JSONDecoder().decode(PlayerClass.self, from: data)
        XCTAssertEqual(playerClass.id.rawValue, 3)
        XCTAssertEqual(playerClass.slug, "hunter")
        XCTAssertEqual(playerClass.cardID?.rawValue, 31)
        XCTAssertEqual(playerClass.name, "Hunter")
    }
}
