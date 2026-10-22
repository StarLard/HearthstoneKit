//
//  ConformanceTests.swift
//  HearthstoneKit_Tests
//

import Testing
@testable import HearthstoneKit

/// Compile-time checks that public value types stay `Sendable` and `Hashable`. If a type loses either conformance,
/// this file stops compiling.
struct ConformanceTests {
    private func requireSendableAndHashable<T: Sendable & Hashable>(_: T.Type) {}

    @Test func `Value types are Sendable and Hashable`() {
        // Models
        requireSendableAndHashable(Card.self)
        requireSendableAndHashable(Card.Keyword.self)
        requireSendableAndHashable(Card.CardType.self)
        requireSendableAndHashable(Card.CardType.Kind.self)
        requireSendableAndHashable(CardBack.self)
        requireSendableAndHashable(CardBack.SortCategory.self)
        requireSendableAndHashable(Deck.self)
        requireSendableAndHashable(ExpansionSet.self)
        requireSendableAndHashable(ExpansionSet.Group.self)
        requireSendableAndHashable(GameMode.self)
        requireSendableAndHashable(GameMode.Kind.self)
        requireSendableAndHashable(MercenaryRole.self)
        requireSendableAndHashable(MinionType.self)
        requireSendableAndHashable(MinionType.Kind.self)
        requireSendableAndHashable(PlayerClass.self)
        requireSendableAndHashable(PlayerClass.Kind.self)
        requireSendableAndHashable(Rarity.self)
        requireSendableAndHashable(Rarity.CardFormValue.self)
        requireSendableAndHashable(Rarity.Kind.self)
        requireSendableAndHashable(SpellSchool.self)
        requireSendableAndHashable(BattleNetUserInfo.self)

        // Types
        requireSendableAndHashable(BlizzardIdentifier.self)
        requireSendableAndHashable(BattlegroundsTier.self)
        requireSendableAndHashable(Decklist.self)
        requireSendableAndHashable(Decklist.Slot.self)
        requireSendableAndHashable(Deckstring.self)
        requireSendableAndHashable(DeckstringError.self)
        requireSendableAndHashable(GameDataAPIRegion.self)
        requireSendableAndHashable(MetadataKind.self)
        requireSendableAndHashable(OAuthAPIRegion.self)
        requireSendableAndHashable(PlayerLocale.self)

        // API
        requireSendableAndHashable(APIServiceError.self)
        requireSendableAndHashable(BattleNetAPI.AccessToken.self)
        requireSendableAndHashable(BattleNetAPI.Authorization.self)
        requireSendableAndHashable(HearthstoneAPI.CardSearch.self)
        requireSendableAndHashable(HearthstoneAPI.CardSearch.SortPriority.self)
        requireSendableAndHashable(HearthstoneAPI.CardSearch.SortOrder.self)
        requireSendableAndHashable(HearthstoneAPI.CardBackSearch.self)
        requireSendableAndHashable(HearthstoneAPI.CardBackSearch.SortPriority.self)
        requireSendableAndHashable(HearthstoneAPI.CardBackSearch.SortOrder.self)
        requireSendableAndHashable(HearthstoneKit.Configuration.self)
        requireSendableAndHashable(MetadataSummary.self)
    }
}
