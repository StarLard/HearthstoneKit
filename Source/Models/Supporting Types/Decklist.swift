//
//  Decklist.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/21/20.
//

import Foundation

/// Describes the contents of a Card Deck
public struct Decklist: Sequence {
    // MARK: Properties (Public)
    
    private var slots: Array<Element>
    
    /// Dictionary where keys are mana costs and values are quantities. All cards over 7 cost are grouped under the cost 7.
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
    
    public var count: Int {
        return slots.reduce(into: 0, { (counter, pair) in
            counter += pair.quantity
        })
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
            guard lhs.id != rhs.id else { return nil }
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
    
    // MARK: Sequence & IteratorProtocol
       
    public __consuming func makeIterator() -> Array<Element>.Iterator {
        return slots.makeIterator()
    }
    
    public typealias Element = Slot
}

// MARK: - Methods (Public)

extension Decklist {
    /// Increments the quantity of the given card
    ///
    /// Complexity: O(log *n*), where *n* is the number of slots in the decklist, if an existing card is being
    /// incremented. O(*n*), if a new card is being inserted.
    ///
    /// - Parameter card: The card to increment the quantity of.
    /// - Parameter cardLimit: (Optional) A limit on the quantity of the card being incremented that will
    /// be enforced while incrementing. If incrementing the card would exceed the given limit. the decklist will not be
    /// modified. Defaults to 2.
    ///
    /// - Returns: `true` if the quantity of the card was incremented, `false` otherwise.
    @discardableResult
    public mutating func incrementCard(_ card: Card, cardLimit: Int? = 2) -> Bool {
        guard count < 30 else { return false }
        switch indexOf(card: card, withinRange: 0 ..< slots.count) {
        case .hit(let index):
            var slot = slots[index]
            if let limit = cardLimit, slot.quantity + 1 > limit {
                return false
            }
            slot.increment()
            slots[index] = slot
            return true
        case .noHit(let index):
            let element = Element(card: card, quantity: 1)
            slots.insert(element, at: index)
            return true
        }
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
        guard count > 0 else { return false }
        switch indexOf(card: card, withinRange: 0 ..< slots.count) {
        case .hit(let index):
            decrementCard(atIndex: index)
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
    /// - Parameter index: The position of the slot  to remove. `index` must be a valid
    /// `index` of the decklist that is not equal to the decklist's end index.
    public mutating func decrementCard(atIndex index: Int) {
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
        guard count > 0 else { return nil }
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
    public struct Slot {
        public let card: Card
        public private(set) var quantity: Int
        
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
