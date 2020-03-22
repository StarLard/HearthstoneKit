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
    func testAuthenticateFromNetwork() {
        let locale: PlayerLocale = .enUS
        Keychain.clearData(for: .battleNetAccessToken)
        XCTAssertNil(getCachedToken(for: locale))
        
        let tokenExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        
        let authSubscriber = BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion).sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                completeExpectation.fulfill()
            }
        }) { (token) in
            guard let justCachedToken = self.getCachedToken(for: locale) else {
                XCTFail("Access token which was just requested was not in cache")
                return
            }
            XCTAssertEqual(justCachedToken, token)
            XCTAssertFalse(token.isExpired)
            tokenExpectation.fulfill()
        }
        
        wait(for: [tokenExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        authSubscriber.cancel()
    }
    
    func testAuthenticateFromCache() {
        let locale: PlayerLocale = .enUS
        
        guard let alreadyCachedToken = getCachedToken(for: locale) else {
            XCTFail("No token in cache")
            return
        }
        
        let tokenExpectation = XCTestExpectation()
        let completeExpectation = XCTestExpectation()
        
        let authSubscriber = BattleNetAPI.getAccessToken(with: .shared, for: locale.oauthAPIRegion).sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .finished:
                completeExpectation.fulfill()
            }
        }) { (token) in
            XCTAssertEqual(alreadyCachedToken, token)
            tokenExpectation.fulfill()
        }
        wait(for: [tokenExpectation, completeExpectation], timeout: 10, enforceOrder: true)
        authSubscriber.cancel()
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
