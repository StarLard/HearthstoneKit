//
//  BattleNetAPITests.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 3/14/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

extension LiveAPITests {
    @Suite struct BattleNetAPITests {
        let locale: PlayerLocale = .enUS

        init() async throws {
            try await configureSDKIfNeeded()
        }

        @Test func `Authenticate from network`() async throws {
            Keychain.clearData(for: .battleNetAccessToken)
            #expect(try getCachedToken() == nil)

            let token = try await BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion)
            let justCachedToken = try #require(try getCachedToken(), "Access token which was just requested was not in cache")
            #expect(justCachedToken == token)
            #expect(!token.isExpired)
        }

        @Test func `Authenticate from cache`() async throws {
            // Make sure a token is cached rather than depending on another test having run first.
            _ = try await BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion)
            let alreadyCachedToken = try #require(try getCachedToken(), "No token in cache")
            let token = try await BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion)
            #expect(alreadyCachedToken == token)
        }
    }
}

// MARK: Helpers

private extension LiveAPITests.BattleNetAPITests {
    func getCachedToken() throws -> BattleNetAPI.AccessToken? {
        guard let tokenData = Keychain.retrieveData(for: .battleNetAccessToken) else {
            return nil
        }
        return try JSONDecoder().decode(BattleNetAPI.AccessToken.self, from: tokenData)
    }
}
