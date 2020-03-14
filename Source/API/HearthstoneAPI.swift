//
//  HearthstoneAPI.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation
import Combine

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
    ///   - textFilter: A text string used to filter cards. You must include a locale along with the textFilter parameter. The default value is `nil`.
    ///   - gameMode: A recognized game mode (for example, battlegrounds or constructed). The default value is `constructed`. See the [Game Modes Guide](https://develop.battle.net/documentation/hearthstone/guides/game-modes) for more information.
    ///   - page: A page number. The default value is `1`.
    ///   - pageSize: The number of results to choose per page. A value will be selected automatically if you do not supply a pageSize or if the pageSize is higher
    ///    than the maximum allowed. The default value is `nil`.
    ///   - sort: The field used to sort the results. Results are sorted by `manaCost` by default. Cards will also be sorted by class automatically in most cases.
    ///   - order: The order in which to sort the results. The default value is `ascending`.
    /// - Returns: A publisher which can be canceled and sends a `CardSearch` if the request succeeds or an error on failure.
    public static func searchCards(with session: URLSession = .shared, for locale: PlayerLocale, setSlug: String? = nil, classSlug: String? = nil,
                    manaCost: [Int]? = nil, attack: [Int]? = nil, health: [Int]? = nil, collectible: Bool? = nil,
                    raritySlug: String? = nil, typeSlug: String? = nil, minionTypeSlug: String? = nil, keywordSlug: String? = nil,
                    textFilter: String? = nil, gameMode: GameMode.Kind = .constructed, page: Int = 1, pageSize: Int? = nil,
                    sort: CardSearch.SortPriority = .manaCost, order: CardSearch.SortOrder = .ascending) -> AnyPublisher<CardSearch, Error> {
        
        return BattleNetAPI.authenticate(with: session, for: locale).flatMap({ (accessToken) -> AnyPublisher<CardSearch, Error> in
            return searchCards(with: accessToken, session: session, for: locale, setSlug: setSlug,
                              classSlug: classSlug, manaCost: manaCost, attack: attack, health: health,
                              collectible: collectible, raritySlug: raritySlug, typeSlug: typeSlug,
                              minionTypeSlug: minionTypeSlug, keywordSlug: keywordSlug, textFilter: textFilter,
                              gameMode: gameMode, page: page, pageSize: pageSize, sort: sort, order: order)
        })
        .eraseToAnyPublisher()
    }
    
    /// Returns the card with an ID or slug that matches the one you specify. For more information, see the [Card Search Guide](https://develop.battle.net/documentation/hearthstone/guides).
    /// - Parameters:
    ///   - session: A `URLSession` to create the request in. The default value is `shared`.
    ///   - locale: The locale to reflect in localized data.
    ///   - slug: An ID or slug that uniquely identifies a card. You can discover these values by using `HearthstoneAPI.searchCards()`.
    ///   - gameMode: A recognized game mode (for example, battlegrounds or constructed). The default value is `constructed`. See the [Game Modes Guide](https://develop.battle.net/documentation/hearthstone/guides/game-modes) for more information.
    public static func card(with session: URLSession = .shared, for locale: PlayerLocale, slug: String, gameMode: GameMode.Kind = .constructed) -> AnyPublisher<Card, Error> {
        return BattleNetAPI.authenticate(with: session, for: locale).flatMap({ (accessToken) -> AnyPublisher<Card, Error> in
            return card(with: accessToken, session: session, for: locale, slug: slug, gameMode: gameMode)
        })
        .eraseToAnyPublisher()
    }
    
    // MARK: - Card Backs
    // MARK: - Decks
    // MARK: - Metadata
}

// MARK: - Private

private extension HearthstoneAPI {
    static func searchCards(with accessToken: BattleNetAPI.AccessToken, session: URLSession = .shared, for locale: PlayerLocale, setSlug: String?, classSlug: String?,
                           manaCost: [Int]?, attack: [Int]?, health: [Int]?, collectible: Bool?, raritySlug: String?, typeSlug: String?,
                           minionTypeSlug: String?, keywordSlug: String?, textFilter: String?, gameMode: GameMode.Kind, page: Int,
                           pageSize: Int?, sort: CardSearch.SortPriority, order: CardSearch.SortOrder) -> AnyPublisher<CardSearch, Error> {
        
        switch gameMode {
        case .battlegrounds, .constructed:
            break
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
        
        var components = URLComponents()
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/cards"
        components.queryItems = parameters
        
        let request: URLRequest = URLRequest(url: components.url!)
        return session.dataTaskPublisher(for: request)
            .tryExtractData()
            .decode(type: CardSearch.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    static func card(with accessToken: BattleNetAPI.AccessToken, session: URLSession, for locale: PlayerLocale, slug: String, gameMode: GameMode.Kind) -> AnyPublisher<Card, Error> {
        var components = URLComponents()
        components.host = locale.gameDataAPIRegion.host
        components.path = "/hearthstone/cards/\(slug)"
        components.queryItems = [URLQueryItem(name: "access_token", value: accessToken.value),
                                 URLQueryItem(name: "gameMode", value: gameMode.rawValue),
                                 URLQueryItem(name: "locale", value: locale.rawValue)]
        
        let request: URLRequest = URLRequest(url: components.url!)
        return session.dataTaskPublisher(for: request)
            .tryExtractData()
            .decode(type: Card.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
