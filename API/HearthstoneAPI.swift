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
    func cardSearch(session: URLSession = .shared, locale: PlayerLocale, setSlug: String? = nil, classSlug: String? = nil,
                    manaCost: [Int]? = nil, attack: [Int]? = nil, health: [Int]? = nil, collectible: Bool? = nil,
                    raritySlug: String? = nil, typeSlug: String? = nil, minionTypeSlug: String? = nil, keywordSlug: String? = nil,
                    textFilter: String? = nil, gameMode: GameMode.Kind = .constructed, page: Int = 1, pageSize: Int? = nil,
                    sort: CardSearch.SortPriority = .manaCost, order: CardSearch.SortOrder = .ascending) -> AnyPublisher<CardSearch, Error> {
        let request: URLRequest = URLRequest(url: locale.apiRegion.host)
        return session.dataTaskPublisher(for: request)
            .tryExtractData()
            .decode(type: CardSearch.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
        
    }
    
    // MARK: - Card Backs
    // MARK: - Decks
    // MARK: - Metadata
}
