//
//  BattleNetAPIRequestTests.swift
//  HearthstoneKit_Tests
//

import Foundation
import Testing
@testable import HearthstoneKit

/// Offline tests for the OAuth token request. These only build the request, so they never touch the network or the keychain.
struct BattleNetAPIRequestTests {
    let expectedBasicCredentials = "Basic " + Data("client-id:client-secret".utf8).base64EncodedString()

    @Test func `Client credentials request uses Basic auth and a form body`() throws {
        let request = BattleNetAPI.accessTokenRequest(for: .us, authorization: nil, clientID: "client-id", clientSecret: "client-secret")

        let url = try #require(request.url)
        #expect(url.absoluteString == "https://oauth.battle.net/token")
        #expect(request.httpMethod == "POST")
        #expect(request.value(forHTTPHeaderField: "Authorization") == expectedBasicCredentials)
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded")
        #expect(request.httpBody.map { String(decoding: $0, as: UTF8.self) } == "grant_type=client_credentials")
    }

    @Test func `Authorization code request sends client credentials and an encoded form body`() throws {
        let authorization = BattleNetAPI.Authorization(authorizationCode: "abc+123", redirectURI: "https://example.com/callback?x=1&y=2",
                                                       scopes: "openid wow.profile", region: .eu)
        let request = BattleNetAPI.accessTokenRequest(for: .eu, authorization: authorization, clientID: "client-id", clientSecret: "client-secret")

        let url = try #require(request.url)
        #expect(url.query == nil)
        #expect(request.value(forHTTPHeaderField: "Authorization") == expectedBasicCredentials)
        #expect(request.httpBody.map { String(decoding: $0, as: UTF8.self) } == [
            "grant_type=authorization_code",
            "code=abc%2B123",
            "redirect_uri=https%3A%2F%2Fexample.com%2Fcallback%3Fx%3D1%26y%3D2",
            "scope=openid%20wow.profile",
        ].joined(separator: "&"))
    }

    @Test(arguments: [
        (OAuthAPIRegion.us, "oauth.battle.net"),
        (.eu, "oauth.battle.net"),
        (.apac, "oauth.battle.net"),
        (.cn, "oauth.battlenet.com.cn"),
    ])
    func `Token requests go to the region's OAuth host`(region: OAuthAPIRegion, expectedHost: String) {
        let request = BattleNetAPI.accessTokenRequest(for: region, authorization: nil, clientID: "client-id", clientSecret: "client-secret")
        #expect(request.url?.host == expectedHost)
    }
}
