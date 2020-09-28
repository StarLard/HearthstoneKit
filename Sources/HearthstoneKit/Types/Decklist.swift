//
//  Decklist.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/21/20.
//

import Foundation

/// A data structure which represents the cards contented in a Hearthstone Deck
///
/// Decklist leverages a binary search algorithm to keep the decklist sorted as it would appear in-game and
/// optimize card increment and decrement operations.
public struct Decklist: Sequence, Codable, Hashable {
    // MARK: Properties (Public)
    
    private var slots: Array<Element>
    
    /// A mapping which represents the mana-curve of the decklist's cards.
    ///
    /// The curve is represented as a dictionary where keys are mana costs and values are the quantity of cards
    /// at that cost. All cards over 7 mana are grouped under 7 mana (as is done in-game).
    public var manaCurve: Dictionary<Int, Int> {
        var curve =  Dictionary(grouping: slots, by: { (pair) -> Int in
            let cost = pair.card.manaCost
            if cost > 6 {
                return 7
            }
            return cost
        }).mapValues({ (pairs) -> Int in
            pairs.reduce(into: 0, { (accumulator, pair) in
                accumulator += pair.quantity
            })
        })
        for i in 0..<8 {
            if curve[i] == nil {
                curve[i] = 0
            }
        }
        return curve
    }
    
    public subscript(index: Int) -> Slot {
        return slots[index]
    }
    
    /// The number of cards in the decklist.
    ///
    /// Complexity: O(*n*), where *n* is the number of slots in the decklist.
    public var numberOfCards: Int {
        return slots.reduce(into: 0, { (counter, pair) in
            counter += pair.quantity
        })
    }
    
    /// The number of slots in the decklist.
    ///
    /// This is **not** the same as `numberOfCards`.  A decklist with 2 of the same card, only has one slot.
    public var numberOfSlots: Int {
        return slots.count
    }
    
    /// An array reprsentation of the cards in the decklist
    ///
    /// Complexity: O(*nm*), where *n* is the number of slots in the decklist and *m* is the quantity of a card in
    /// a given slot.
    public var cards: [Card] {
        var temp: [Card] = []
        for slot in self {
            for _ in 0..<slot.quantity {
                temp.append(slot.card)
            }
        }
        return temp
    }
    
    // MARK: Properties (Private)
    
    /// A predicate that returns true if its first card should be ordered before its second card, false if visa-versa,
    /// or `nil` if the cards are equal.
    private let areInIncreasingOrder: (Card, Card) -> Bool?
    
    // MARK: Init
    
    /// Creates a decklist from a dictionary that describes a decklist
    ///
    /// - Parameters:
    ///   - cards: Dictionary where keys are cards and values are quantities
    ///   - areInIncreasingOrder: (Optional) A predicate that returns true if its first card should
    ///   be ordered before its second card, false if visa-versa, or `nil` if the cards are equal. The default
    ///   sorting will priortizing cards firstly by manacost and secondly alphabetically by name.
    public init(cards: [Card] = [],
                areInIncreasingOrder: @escaping ((_ lhs: Card, _ rhs: Card) -> Bool?) =
        { (lhs: Card, rhs: Card) -> Bool? in
            guard lhs != rhs else { return nil }
            if lhs.manaCost != rhs.manaCost {
                return lhs.manaCost < rhs.manaCost
            } else {
                return lhs.name < rhs.name
            }
        }) {
        var cardQuantities: [Card: Int] = [:]
        for card in cards {
            if let quantity = cardQuantities[card] {
                cardQuantities[card] = quantity + 1
            } else {
                cardQuantities[card] = 1
            }
        }
        self.slots = cardQuantities.map({ (card, quantity) -> Slot in
            Slot(card: card, quantity: quantity)
        }).sorted(by: {(lhs: Slot, rhs: Slot) -> Bool in
            areInIncreasingOrder(lhs.card, rhs.card) ?? true
        })
        self.areInIncreasingOrder = areInIncreasingOrder
    }
    
    // MARK: Protocol
       
    public __consuming func makeIterator() -> Array<Element>.Iterator {
        return slots.makeIterator()
    }
    
    public typealias Element = Slot
    
    public init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        self.init(cards: try value.decode(Array<Card>.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(cards)
    }
    
    public static func == (lhs: Decklist, rhs: Decklist) -> Bool {
        return lhs.slots == rhs.slots
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(slots)
    }
}

// MARK: - Methods (Public)

extension Decklist {
    /// Increments the quantity of the given card
    ///
    /// Complexity: O(log *n*), where *n* is the number of slots in the decklist, if an existing card is being
    /// incremented. O(*n*), if a new card is being inserted.
    ///
    /// - Parameters:
    ///   - card: The card to increment the quantity of.
    ///   - slotLimit: (Optional) A limit on the quantity of the card at a given slot being incremented that will
    ///   be enforced while incrementing. If incrementing the card would exceed the given limit. the decklist will not be
    ///   modified. Defaults to 2.
    ///   - cardLimit: (Optional) A limit on the quantity of cards in the decklist that will be enforced while incrementing.
    ///   If incrementing the card would exceed the given limit. the decklist will not be modified. Defaults to 30.
    ///
    /// - Returns: `true` if the quantity of the card was incremented, `false` otherwise.
    @discardableResult
    public mutating func incrementCard(_ card: Card, slotLimit: Int? = 2, cardLimit: Int? = 30) -> Bool {
        if let limit = cardLimit, numberOfCards + 1 > limit {
            return false
        }
        switch indexOf(card: card, withinRange: 0 ..< slots.count) {
        case .hit(let index):
            return incrementCard(at: index, slotLimit: slotLimit, cardLimit: cardLimit)
        case .noHit(let index):
            let element = Element(card: card, quantity: 1)
            slots.insert(element, at: index)
            return true
        }
    }
    
    /// Increments the quantity of the given card
    ///
    /// Complexity: O(log *n*), where *n* is the number of slots in the decklist, if an existing card is being
    /// incremented. O(*n*), if a new card is being inserted.
    ///
    /// - Parameters:
    ///   - index: The position of the card  to increment. `index` must be a valid
    ///  `index` of the decklist that is not equal to the decklist's end index.
    ///   - slotLimit: (Optional) A limit on the quantity of the card at a given slot being incremented that will
    ///   be enforced while incrementing. If incrementing the card would exceed the given limit. the decklist will not be
    ///   modified. Defaults to 2.
    ///   - cardLimit: (Optional) A limit on the quantity of cards in the decklist that will be enforced while incrementing.
    ///   If incrementing the card would exceed the given limit. the decklist will not be modified. Defaults to 30.
    ///
    /// - Returns: `true` if the quantity of the card was incremented, `false` otherwise.
    @discardableResult
    public mutating func incrementCard(at index: Int, slotLimit: Int? = 2, cardLimit: Int? = 30) -> Bool {
        if let limit = cardLimit, numberOfCards + 1 > limit {
            return false
        }
        var slot = slots[index]
        if let limit = slotLimit, slot.quantity + 1 > limit {
            return false
        }
        slot.increment()
        slots[index] = slot
        return true
    }
    
    /// Removes one instance of the given card
    ///
    /// Complexity: O(log *n*), where *n* is the number of slots in the decklist, if the card is decremented without
    /// causing a slot to be removed. O(*n*) if decrementing causes a slot removal.
    ///
    /// - Parameter card: The card to decrement
    ///
    /// - Returns: true if the quantity of the card was changed, false otherwise
    /// - Note: If the card's quantity drops to 0 it will be removed entirely
    @discardableResult
    public mutating func decrementCard(_ card: Card) -> Bool {
        guard numberOfCards > 0 else { return false }
        switch indexOf(card: card, withinRange: 0 ..< slots.count) {
        case .hit(let index):
            decrementCard(at: index)
            return true
        case .noHit: return false
        }
    }
    
    /// Decrements the card at the given index by one.
    ///
    /// If decrementing the card's quantity causes it to drop to 0, the slot will be removed entirely
    /// from the decklist.
    ///
    /// Complexity: O(1), if the card is decremented without causing a slot to be removed.
    /// O(*n*), where *n* is the number of slots in the decklist, if decrementing causes a slot
    /// removal.
    ///
    /// - Parameter index: The position of the slot  to decrement. `index` must be a valid
    /// `index` of the decklist that is not equal to the decklist's end index.
    public mutating func decrementCard(at index: Int) {
        var pair = slots[index]
        if pair.decrement() {
            slots[index] = pair
        } else {
            slots.remove(at: index)
        }
    }
    
    /// Checks if a given card is in the decklist.
    ///
    /// Complexity: O(log *n*), where *n* is the number of slots in the decklist.
    ///
    /// - Parameter card: The card to check the decklist for.
    /// - Returns: The index of the card if present; otherwise `nil`
    public func contains(_ card: Card) -> Int? {
        guard numberOfCards > 0 else { return nil }
        switch indexOf(card: card, withinRange: 0 ..< slots.count) {
        case .hit(let index):
            return index
        case .noHit: return nil
        }
    }
}

// MARK: - Binary Search

private extension Decklist {
    enum SearchResult {
        case hit(Int)
        case noHit(Int)
    }
    
    /// Searches for a card in the deck using binary search.
    ///
    /// Used to to find the correct insertion/deletion position.
    ///
    /// - Parameters:
    ///   - card: The card to insert
    ///   - range: The range of the deck to insert into. Should always use the whole array
    ///
    /// - Returns: A `SearchResult` where `.hit` contains an `Int` which indicates
    /// the index the found card and `noHit` contains an `Int` which indicates the index at which
    /// the card should be inserted.
    ///
    /// Complexity: O(log *n*), where *n* is the number of slots in the decklist.
    func indexOf(card: Card, withinRange range: Range<Int>) -> SearchResult {
        if range.lowerBound >= range.upperBound {
            // NOTE: If we get here, then the card is not yet present in the decklist.
            return SearchResult.noHit(range.lowerBound)
        } else {
            // NOTE: Calculate where to split the decklist.
            let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
            guard let cardComesAfterMiddleCard = areInIncreasingOrder(slots[midIndex].card, card) else {
                // NOTE: If we get here, then we've found the card.
                return SearchResult.hit(midIndex)
            }
            if cardComesAfterMiddleCard {
                // NOTE: Check for the card in the right half of the decklist.
                return indexOf(card: card, withinRange: midIndex + 1 ..< range.upperBound)
            } else {
                // NOTE: Check for the card in the left half of the decklist.
                return indexOf(card: card, withinRange: range.lowerBound ..< midIndex)
            }
        }
    }
}

// MARK: - Slot

extension Decklist {
    /// Represents a "slot" in a decklist
    ///
    /// A slot is a position within the decklist which defines the card at that position and the quantity
    /// of it.
    public struct Slot: Hashable {
        public let card: Card
        public private(set) var quantity: Int
        
        public init(card: Card, quantity: Int) {
            self.card = card
            self.quantity = quantity
        }
        
        /// Increases the card's quantity by one.
        fileprivate mutating func increment() {
            var count = quantity
            count += 1
            self.quantity = count
        }
        
        /// Reduces the card's quantity by one if it can drop further without going below 0.
        ///
        /// - Returns: `true` if the card quantity was decremented, `false` otherwise.
        fileprivate mutating func decrement() -> Bool {
            var count = quantity
            count -= 1
            if count > 0 {
                self.quantity = count
                return true
            } else {
                return false
            }
        }
    }
}
