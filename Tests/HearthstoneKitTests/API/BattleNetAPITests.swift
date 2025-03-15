//
//  BattleNetAPITests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 3/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

final class BattleNetAPITests: HSKitTestCase {
    func testAuthenticateFromNetwork() async throws {
        let locale: PlayerLocale = .enUS
        Keychain.clearData(for: .battleNetAccessToken)
        XCTAssertNil(getCachedToken(for: locale))

        let token = try await BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion)
        let justCachedToken = try XCTUnwrap(self.getCachedToken(for: locale), "Access token which was just requested was not in cache")
        XCTAssertEqual(justCachedToken, token)
        XCTAssertFalse(token.isExpired)
    }
    
    func testAuthenticateFromCache() async throws {
        let locale: PlayerLocale = .enUS
        let alreadyCachedToken = try XCTUnwrap(getCachedToken(for: locale), "No token in cache")
        let token = try await BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion)
        XCTAssertEqual(alreadyCachedToken, token)
    }
}

// MARK: Helpers

private extension BattleNetAPITests {
    func getCachedToken(for locale: PlayerLocale) -> BattleNetAPI.AccessToken? {
        guard let tokenData = Keychain.retrieveData(for: .battleNetAccessToken) else {
            return nil
        }
        XCTAssertNoThrow(try JSONDecoder().decode(BattleNetAPI.AccessToken.self, from: tokenData))
        return try? JSONDecoder().decode(BattleNetAPI.AccessToken.self, from: tokenData)
    }
}
