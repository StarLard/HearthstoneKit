//
//  HearthstoneAPI.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation
import Combine

/// An interface with methods to consume the Hearthstone API.
public enum HearthstoneAPI {
    // MARK: - Cards

    /// Returns an up-to-date list of all cards matching the search criteria. For more information about the search parameters,
    /// see the [Card Search Guide](https://develop.battle.net/documentation/hearthstone/guides).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - setSlug: The slug of the set the card belongs to. If you do not supply a value, cards from all sets will be returned. The default value is `nil`.
    ///   - classSlug: The slug of the card's class. The default value is `nil`.
    ///   - manaCost: The mana cost required to play the card. You can include multiple values in a list. The default value is `nil`.
    ///   - attack: The attack power of the minion or weapon. You can include multiple values in a list. The default value is `nil`.
    ///   - health: The health of a minion. You can include multiple values in a list. The default value is `nil`.
    ///   - collectible: Whether a card is collectible. `true` indicates that collectible cards should be returned; `false` indicates uncollectible cards.
    ///   To return all cards, use `nil`. The default value is `nil`.
    ///   - raritySlug: The rarity of a card. This value must match the rarity slugs found in metadata. The default value is `nil`.
    ///   - typeSlug: The type of card (for example, minion, spell, and so on). This value must match the type slugs found in metadata. The default value is
    ///   `nil`.
    ///   - minionTypeSlug: The type of minion card (for example, beast, murloc, dragon, and so on). This value must match the minion type slugs found in
    ///    metadata. The default value is `nil`.
    ///   - keywordSlug: A required keyword on the card (for example, battlecry, deathrattle, and so on). This value must match the keyword slugs found in
    ///    metadata. The default value is `nil`.
    ///   - textFilter: A text string used to filter cards. The default value is `nil`.
    ///   - page: A page number. The default value is `1`.
    ///   - pageSize: The number of results to choose per page. A value will be selected automatically if you do not supply a pageSize or if the pageSize is higher
    ///    than the maximum allowed. The default value is `nil`.
    ///   - sort: The field used to sort the results. Results are sorted by `manaCost` by default. Cards will also be sorted by class automatically in most cases.
    ///   - order: The order in which to sort the results. The default value is `ascending`.
    /// - Returns: A publisher which can be canceled and sends a `CardSearch` if the request succeeds or an error on failure.
    public static func searchConstructedCards(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        setSlug: String? = nil,
        classSlug: String? = nil,
        manaCost: [Int]? = nil,
        attack: [Int]? = nil,
        health: [Int]? = nil,
        collectible: Bool? = nil,
        raritySlug: String? = nil,
        typeSlug: String? = nil,
        minionTypeSlug: String? = nil,
        keywordSlug: String? = nil,
        textFilter: String? = nil,
        page: Int = 1,
        pageSize: Int? = nil,
        sort: CardSearch.SortPriority = .manaCost,
        order: CardSearch.SortOrder = .ascending
    ) async throws -> CardSearch {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestCards(
            with: accessToken,
            session: session,
            for: locale,
            setSlug: setSlug,
            classSlug: classSlug,
            manaCost: manaCost,
            attack: attack,
            health: health,
            collectible: collectible,
            raritySlug: raritySlug,
            typeSlug: typeSlug,
            minionTypeSlug: minionTypeSlug,
            keywordSlug: keywordSlug,
            textFilter: textFilter,
            gameMode: .constructed,
            tiers: nil,
            page: page,
            pageSize: pageSize,
            sort: sort,
            order: order
        )
    }

    /// Returns an up-to-date list of all cards matching the search criteria. For more information about the search parameters,
    /// see the [Card Search Guide](https://develop.battle.net/documentation/hearthstone/guides).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - setSlug: The slug of the set the card belongs to. If you do not supply a value, cards from all sets will be returned. The default value is `nil`.
    ///   - classSlug: The slug of the card's class. The default value is `nil`.
    ///   - manaCost: The mana cost required to play the card. You can include multiple values in a list. The default value is `nil`.
    ///   - attack: The attack power of the minion or weapon. You can include multiple values in a list. The default value is `nil`.
    ///   - health: The health of a minion. You can include multiple values in a list. The default value is `nil`.
    ///   - collectible: Whether a card is collectible. `true` indicates that collectible cards should be returned; `false` indicates uncollectible cards.
    ///   To return all cards, use `nil`. The default value is `nil`.
    ///   - raritySlug: The rarity of a card. This value must match the rarity slugs found in metadata. The default value is `nil`.
    ///   - typeSlug: The type of card (for example, minion, spell, and so on). This value must match the type slugs found in metadata. The default value is
    ///   `nil`.
    ///   - minionTypeSlug: The type of minion card (for example, beast, murloc, dragon, and so on). This value must match the minion type slugs found in
    ///    metadata. The default value is `nil`.
    ///   - keywordSlug: A required keyword on the card (for example, battlecry, deathrattle, and so on). This value must match the keyword slugs found in
    ///    metadata. The default value is `nil`.
    ///   - tiers: This special parameter is for tavern tier, which is only recognized when searching for Battlegrounds cards. The default value is `nil`.
    ///   - textFilter: A text string used to filter cards. The default value is `nil`.
    ///   - page: A page number. The default value is `1`.
    ///   - pageSize: The number of results to choose per page. A value will be selected automatically if you do not supply a pageSize or if the pageSize is higher
    ///    than the maximum allowed. The default value is `nil`.
    ///   - sort: The field used to sort the results. Results are sorted by `manaCost` by default. Cards will also be sorted by class automatically in most cases.
    ///   - order: The order in which to sort the results. The default value is `ascending`.
    /// - Returns: A publisher which can be canceled and sends a `CardSearch` if the request succeeds or an error on failure.
    public static func searchBattlegroundsCards(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        setSlug: String? = nil,
        classSlug: String? = nil,
        manaCost: [Int]? = nil,
        attack: [Int]? = nil,
        health: [Int]? = nil,
        collectible: Bool? = nil,
        raritySlug: String? = nil,
        typeSlug: String? = nil,
        minionTypeSlug: String? = nil,
        keywordSlug: String? = nil,
        textFilter: String? = nil,
        tiers: [BattlegroundsTier]? = nil,
        page: Int = 1, pageSize: Int? = nil,
        sort: CardSearch.SortPriority = .manaCost,
        order: CardSearch.SortOrder = .ascending
    )
    async throws -> CardSearch {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestCards(
            with: accessToken,
            session: session,
            for: locale,
            setSlug: setSlug,
            classSlug: classSlug,
            manaCost: manaCost,
            attack: attack,
            health: health,
            collectible: collectible,
            raritySlug: raritySlug,
            typeSlug: typeSlug,
            minionTypeSlug: minionTypeSlug,
            keywordSlug: keywordSlug,
            textFilter: textFilter,
            gameMode: .battlegrounds,
            tiers: tiers,
            page: page,
            pageSize: pageSize,
            sort: sort,
            order: order
        )
    }

    /// Returns the card with an ID or slug that matches the one you specify. For more information,
    /// see the [Card Search Guide](https://develop.battle.net/documentation/hearthstone/guides).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - idOrSlug: An ID or slug that uniquely identifies a card. You can discover these values by using `HearthstoneAPI.searchConstructedCards()`
    ///   or `HearthstoneAPI.searchBattlegroundsCards()`.
    ///   - gameMode: A recognized game mode (for example, battlegrounds or constructed). The default value is `constructed`. See the
    ///   [Game Modes Guide](https://develop.battle.net/documentation/hearthstone/guides/game-modes) for more information.
    /// - Returns: A publisher which can be canceled and sends a `Card` if the request succeeds or an error on failure.
    public static func getCard(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        idOrSlug: String,
        gameMode: GameMode.Kind = .constructed
    ) async throws -> Card {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestCard(with: accessToken, session: session, for: locale, idOrSlug: idOrSlug, gameMode: gameMode)
    }

    // MARK: - Card Backs

    /// Returns an up-to-date list of all card backs matching the search criteria. For more information about the search parameters,
    /// see the [Card Search Guide](https://develop.battle.net/documentation/hearthstone/guides).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - cardBackCategory: A category of the card back. The category must match a valid category. The default value is `nil`.
    ///   - textFilter: A text string used to filter card backs. The default value is `nil`.
    ///   - sort: The field used to sort the results. Results are sorted by `date` by default.
    ///   - order: The order in which to sort the results. The default value is `descending`.
    /// - Returns: A publisher which can be canceled and sends a `CardBackSearch` if the request succeeds or an error on failure.
    public static func searchCardBacks(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        cardBackCategory: String? = nil,
        textFilter: String? = nil,
        sort: CardBackSearch.SortPriority = .date,
        order: CardBackSearch.SortOrder = .descending
    ) async throws -> CardBackSearch {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestCardBacks(with: accessToken, session: session, for: locale, cardBackCategory: cardBackCategory,
                                          textFilter: textFilter, sort: sort, order: order)
    }

    /// Returns a specific card back by using card back ID or slug.
    /// see the [Card Search Guide](https://develop.battle.net/documentation/hearthstone/guides).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - idOrSlug: An ID or slug that uniquely identifies a card back. You can discover these values by using `HearthstoneAPI.searchCardBacks()`.
    /// - Returns: A publisher which can be canceled and sends a `Card` if the request succeeds or an error on failure.
    public static func getCardBack(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        idOrSlug: String
    ) async throws -> CardBack {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestCardBack(with: accessToken, session: session, for: locale, idOrSlug: idOrSlug)
    }

    // MARK: - Decks

    /// Finds a deck by its deck code. For more information, see the
    /// [Retrieving Decks Guide](https://develop.battle.net/documentation/hearthstone/guides/decks).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - deckcode: A code that identifies a deck. You can get one from a `Deckstring` or you copy one from the game or various Hearthstone websites.
    /// - Returns: A publisher which can be canceled and sends a `Deck` if the request succeeds or an error on failure.
    public static func getDeck(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        deckcode: String
    ) async throws -> Deck {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestDeck(with: accessToken, session: session, for: locale, deckcode: deckcode)
    }

    // MARK: - Metadata

    /// Returns information about just one type of metadata. For more information, see the
    /// [Metadata Guide](https://develop.battle.net/documentation/hearthstone/guides/metadata).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - metadataType: The type of the metadata to retrieve. Valid values include `ExpansionSet`, `ExpansionSet.Group`, `Rarity`,
    ///   `Card.Keyword`, `PlayerClass`, `Card.CardType`, and `MinionType`.
    /// - Returns: A publisher which can be canceled and sends a `MetadataType` if the request succeeds or an error on failure.
    public static func getMetadata<MetadataType: Metadata>(
        with session: URLSession = .shared,
        for locale: PlayerLocale,
        metadataType: MetadataType.Type
    ) async throws -> Set<MetadataType> {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestMetadata(with: accessToken, session: session, for: locale, metadataType: metadataType)
    }

    /// Returns information about the categorization of cards. Metadata includes the card set, set group (for example, Standard or Year of
    ///  the Dragon), rarity, class, card type, minion type, and keywords. For more information, see the
    ///  [Metadata Guide](https://develop.battle.net/documentation/hearthstone/guides/metadata).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    /// - Returns: A publisher which can be canceled and sends a `MetadataSummary` if the request succeeds or an error on failure.
    public static func getAllMetadata(
        with session: URLSession = .shared,
        for locale: PlayerLocale
    ) async throws -> MetadataSummary {
        let accessToken = try await BattleNetAPI.getAccessToken(with: session, for: locale.oauthAPIRegion)
        return try await requestAllMetadata(with: accessToken, session: session, for: locale)
    }
}

// MARK: - Network Requests

private extension HearthstoneAPI {
    private static let decoder = JSONDecoder()

    // MARK: Cards

    static func requestCards(with accessToken: BattleNetAPI.AccessToken, session: URLSession = .shared, for locale: PlayerLocale,
                             setSlug: String?, classSlug: String?, manaCost: [Int]?, attack: [Int]?, health: [Int]?, collectible: Bool?,
                             raritySlug: String?, typeSlug: String?, minionTypeSlug: String?, keywordSlug: String?, textFilter: String?,
                             gameMode: GameMode.Kind, tiers: [BattlegroundsTier]?, page: Int, pageSize: Int?, sort: CardSearch.SortPriority,
                             order: CardSearch.SortOrder) async throws -> CardSearch {

        switch gameMode {
        case .battlegrounds:
            break
        case .constructed:
            assert(tiers == nil)
        case .arena, .unknown:
            assertionFailure("battlegrounds and constructed are the only currently supported game modes.")
        }

        var parameters = [
            URLQueryItem(name: "access_token", value: accessToken.value),
            URLQueryItem(name: "locale", value: locale.rawValue),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "gameMode", value: gameMode.rawValue),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "order", value: order.rawValue),
        ]
        if let value = setSlug {
            parameters.append(URLQueryItem(name: "set", value: value))
        }
        if let value = classSlug {
            parameters.append(URLQueryItem(name: "class", value: value))
        }
        if let value = manaCost {
            parameters.append(URLQueryItem(name: "manaCost", value: value.map(String.init).joined(separator: ",")))
        }
        if let value = attack {
            parameters.append(URLQueryItem(name: "attack", value: value.map(String.init).joined(separator: ",")))
        }
        if let value = health {
            parameters.append(URLQueryItem(name: "health", value: value.map(String.init).joined(separator: ",")))
        }
        if let value = collectible {
            parameters.append(URLQueryItem(name: "collectible", value: value ? "1" : "0"))
        }
        if let value = raritySlug {
            parameters.append(URLQueryItem(name: "rarity", value: value))
        }
        if let value = typeSlug {
            parameters.append(URLQueryItem(name: "type", value: value))
        }
        if let value = minionTypeSlug {
            parameters.append(URLQueryItem(name: "minionType", value: value))
        }
        if let value = keywordSlug {
            parameters.append(URLQueryItem(name: "keyword", value: value))
        }
        if let value = textFilter {
            parameters.append(URLQueryItem(name: "textFilter", value: value))
        }
        if let value = pageSize {
            parameters.append(URLQueryItem(name: "pageSize", value: String(value)))
        }
        if let value = tiers {
            parameters.append(URLQueryItem(name: "tier", value: value.map({$0.rawValue}).joined(separator: ",")))
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/cards"
        components.queryItems = parameters

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(CardSearch.self, for: request, using: decoder)
    }

    static func requestCard(with accessToken: BattleNetAPI.AccessToken, session: URLSession, for locale: PlayerLocale,
                            idOrSlug: String, gameMode: GameMode.Kind) async throws -> Card {
        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/cards/\(idOrSlug)"
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken.value),
                                 URLQueryItem(name: "gameMode", value: gameMode.rawValue),
                                 URLQueryItem(name: "locale", value: locale.rawValue)]

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(Card.self, for: request, using: decoder)
    }

    // MARK: Card Backs

    static func requestCardBacks(with accessToken: BattleNetAPI.AccessToken, session: URLSession, for locale: PlayerLocale,
                                 cardBackCategory: String?, textFilter: String?, sort: CardBackSearch.SortPriority,
                                 order: CardBackSearch.SortOrder) async throws -> CardBackSearch {
        var parameters = [
            URLQueryItem(name: "access_token", value: accessToken.value),
            URLQueryItem(name: "locale", value: locale.rawValue),
            URLQueryItem(name: "sort", value: sort.rawValue),
            URLQueryItem(name: "order", value: order.rawValue),
        ]

        if let value = cardBackCategory {
            parameters.append(URLQueryItem(name: "cardBackCategory", value: value))
        }
        if let value = textFilter {
            parameters.append(URLQueryItem(name: "textFilter", value: value))
        }

        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/cardbacks"
        components.queryItems = parameters

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(CardBackSearch.self, for: request, using: decoder)
    }

    static func requestCardBack(with accessToken: BattleNetAPI.AccessToken, session: URLSession, for locale: PlayerLocale,
                                idOrSlug: String) async throws -> CardBack {
        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/cardbacks/\(idOrSlug)"
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken.value),
                                 URLQueryItem(name: "locale", value: locale.rawValue)]

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(CardBack.self, for: request, using: decoder)
    }

    // MARK: Decks

    static func requestDeck(with accessToken: BattleNetAPI.AccessToken, session: URLSession,
                            for locale: PlayerLocale, deckcode: String) async throws -> Deck {
        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/deck/\(deckcode)"
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken.value),
                                 URLQueryItem(name: "locale", value: locale.rawValue)]

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(Deck.self, for: request, using: decoder)
    }

    // MARK: Metadata

    static func requestMetadata<MetadataType: Metadata>(with accessToken: BattleNetAPI.AccessToken, session: URLSession,
                                                        for locale: PlayerLocale, metadataType: MetadataType.Type) async throws -> Set<MetadataType> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/metadata/\(MetadataType.metadataKind)"
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken.value),
                                 URLQueryItem(name: "locale", value: locale.rawValue)]

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(Set<MetadataType>.self, for: request, using: decoder)
    }

    static func requestAllMetadata(with accessToken: BattleNetAPI.AccessToken, session: URLSession,
                                   for locale: PlayerLocale) async throws -> MetadataSummary {
        var components = URLComponents()
        components.scheme = "https"
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/metadata"
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken.value),
                                 URLQueryItem(name: "locale", value: locale.rawValue)]

        let request: URLRequest = URLRequest(url: components.url!)
        return try await session.value(MetadataSummary.self, for: request, using: decoder)
    }
}
