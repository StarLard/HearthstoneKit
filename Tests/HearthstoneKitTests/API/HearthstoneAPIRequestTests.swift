//
//  HearthstoneAPIRequestTests.swift
//  HearthstoneKit_Tests
//

import Foundation
import Testing
@testable import HearthstoneKit

/// Offline tests for the requests `HearthstoneAPI` builds. These pass the access token directly and use a stubbed session,
/// so they never touch the network or the keychain.
struct HearthstoneAPIRequestTests {
    static var token: BattleNetAPI.AccessToken {
        BattleNetAPI.AccessToken(
            response: .init(value: "test-token", type: "bearer", lifespan: 3600),
            requestTime: Date(),
            authorization: nil,
            region: .us
        )
    }

    enum Endpoint: String, CaseIterable, Sendable {
        case cardSearch
        case card
        case cardBackSearch
        case cardBack
        case deck
        case metadata
        case allMetadata

        var expectedPath: String {
            switch self {
            case .cardSearch: return "/hearthstone/cards"
            case .card: return "/hearthstone/cards/52119-arch-villain-rafaam"
            case .cardBackSearch: return "/hearthstone/cardbacks"
            case .cardBack: return "/hearthstone/cardbacks/155-pizza-stone"
            case .deck: return "/hearthstone/deck/AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA"
            case .metadata: return "/hearthstone/metadata/rarities"
            case .allMetadata: return "/hearthstone/metadata"
            }
        }

        /// Sends this endpoint's request. The stub's empty body won't decode, which is fine: these tests only inspect the request.
        func send(using session: URLSession) async {
            let token = HearthstoneAPIRequestTests.token
            switch self {
            case .cardSearch:
                _ = try? await HearthstoneAPI.requestCards(with: token, session: session, for: .enUS, setSlug: nil, classSlug: nil, manaCost: nil,
                                                           attack: nil, health: nil, collectible: nil, raritySlug: nil, typeSlug: nil,
                                                           minionTypeSlug: nil, keywordSlug: nil, textFilter: nil, gameMode: .constructed, tiers: nil,
                                                           page: 1, pageSize: nil, sort: .manaCost, order: .ascending)
            case .card:
                _ = try? await HearthstoneAPI.requestCard(with: token, session: session, for: .enUS, idOrSlug: "52119-arch-villain-rafaam",
                                                          gameMode: .constructed)
            case .cardBackSearch:
                _ = try? await HearthstoneAPI.requestCardBacks(with: token, session: session, for: .enUS, cardBackCategory: nil, textFilter: nil,
                                                               sort: .date, order: .descending)
            case .cardBack:
                _ = try? await HearthstoneAPI.requestCardBack(with: token, session: session, for: .enUS, idOrSlug: "155-pizza-stone")
            case .deck:
                _ = try? await HearthstoneAPI.requestDeck(with: token, session: session, for: .enUS,
                                                          deckcode: "AAECAR8K7QaHB4f7Ap6dA6CFA9SLA94ElwikpQPHAwr4rwP8rwPslgOFsAPJBIAHhwSNAcMIgQoA")
            case .metadata:
                _ = try? await HearthstoneAPI.requestMetadata(with: token, session: session, for: .enUS, metadataType: Rarity.self)
            case .allMetadata:
                _ = try? await HearthstoneAPI.requestAllMetadata(with: token, session: session, for: .enUS)
            }
        }
    }

    // MARK: Authorization

    @Test(arguments: Endpoint.allCases)
    func `Sends access token as a bearer header, not a query parameter`(endpoint: Endpoint) async throws {
        let (session, stub) = StubURLProtocol.makeSession()
        await endpoint.send(using: session)

        let request = try #require(stub.requests.only)
        let url = try #require(request.url)
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer test-token")
        #expect(!queryItems(of: url).keys.contains("access_token"))
        #expect(url.host == "us.api.blizzard.com")
        #expect(url.path == endpoint.expectedPath)
        #expect(queryItems(of: url)["locale"] == "en_US")
    }

    // MARK: Query Parameters

    @Test func `Constructed card search sends every filter`() async throws {
        let (session, stub) = StubURLProtocol.makeSession()
        _ = try? await HearthstoneAPI.requestCards(with: Self.token, session: session, for: .enUS, setSlug: "rise-of-shadows", classSlug: "mage",
                                                   manaCost: [1, 2], attack: [3], health: [4, 5], collectible: true, raritySlug: "legendary",
                                                   typeSlug: "minion", minionTypeSlug: "dragon", keywordSlug: "battlecry", textFilter: "kalecgos",
                                                   gameMode: .constructed, tiers: nil, page: 2, pageSize: 5, sort: .name, order: .descending)

        let url = try #require(stub.requests.only?.url)
        #expect(queryItems(of: url) == [
            "locale": "en_US",
            "page": "2",
            "pageSize": "5",
            "gameMode": "constructed",
            "sort": "name",
            "order": "desc",
            "set": "rise-of-shadows",
            "class": "mage",
            "manaCost": "1,2",
            "attack": "3",
            "health": "4,5",
            "collectible": "1",
            "rarity": "legendary",
            "type": "minion",
            "minionType": "dragon",
            "keyword": "battlecry",
            "textFilter": "kalecgos",
        ])
    }

    @Test func `Battlegrounds card search sends tiers`() async throws {
        let (session, stub) = StubURLProtocol.makeSession()
        _ = try? await HearthstoneAPI.requestCards(with: Self.token, session: session, for: .enUS, setSlug: nil, classSlug: nil, manaCost: nil,
                                                   attack: nil, health: nil, collectible: false, raritySlug: nil, typeSlug: nil, minionTypeSlug: nil,
                                                   keywordSlug: nil, textFilter: nil, gameMode: .battlegrounds, tiers: [.hero, .three], page: 1,
                                                   pageSize: nil, sort: .attack, order: .ascending)

        let url = try #require(stub.requests.only?.url)
        let query = queryItems(of: url)
        #expect(query["gameMode"] == "battlegrounds")
        #expect(query["tier"] == "hero,3")
        #expect(query["collectible"] == "0")
    }

    @Test func `Card back search sends filters`() async throws {
        let (session, stub) = StubURLProtocol.makeSession()
        _ = try? await HearthstoneAPI.requestCardBacks(with: Self.token, session: session, for: .enUS, cardBackCategory: "base",
                                                       textFilter: "pizza", sort: .name, order: .ascending)

        let url = try #require(stub.requests.only?.url)
        #expect(queryItems(of: url) == [
            "locale": "en_US",
            "cardBackCategory": "base",
            "textFilter": "pizza",
            "sort": "name",
            "order": "asc",
        ])
    }

    // MARK: Responses

    @Test func `Decodes a successful response`() async throws {
        let (session, _) = StubURLProtocol.makeSession(body: try openSampleFile(.cardMinion))
        let card = try await HearthstoneAPI.requestCard(with: Self.token, session: session, for: .enUS, idOrSlug: "52119-arch-villain-rafaam",
                                                        gameMode: .constructed)
        #expect(card.slug == "52119-arch-villain-rafaam")
    }

    @Test(arguments: [401, 404, 500])
    func `Throws for an unsuccessful status code`(statusCode: Int) async throws {
        let (session, _) = StubURLProtocol.makeSession(statusCode: statusCode)
        let error = await #expect(throws: APIServiceError.self) {
            try await HearthstoneAPI.requestCard(with: Self.token, session: session, for: .enUS, idOrSlug: "52119-arch-villain-rafaam",
                                                 gameMode: .constructed)
        }
        #expect(error?.status == statusCode)
    }

    @Test func `Throws an error returned in a successful response`() async throws {
        let body = Data(#"{"status": 403, "statusMessage": "Forbidden", "message": "Account inactive"}"#.utf8)
        let (session, _) = StubURLProtocol.makeSession(body: body)
        let error = await #expect(throws: APIServiceError.self) {
            try await HearthstoneAPI.requestCard(with: Self.token, session: session, for: .enUS, idOrSlug: "52119-arch-villain-rafaam",
                                                 gameMode: .constructed)
        }
        #expect(error?.status == 403)
        #expect(error?.message == "Account inactive")
    }
}

// MARK: Helpers

private extension HearthstoneAPIRequestTests {
    func queryItems(of url: URL) -> [String: String] {
        let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        return Dictionary(items.map { ($0.name, $0.value ?? "") }, uniquingKeysWith: { first, _ in first })
    }
}

private extension Array {
    /// The sole element, or `nil` if the array doesn't contain exactly one.
    var only: Element? { count == 1 ? first : nil }
}
