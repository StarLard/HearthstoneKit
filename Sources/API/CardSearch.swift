//
//  CardSearch.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation

extension HearthstoneAPI {
    public struct CardSearch: Decodable {
        public let cardCount: Int
        public let pageCount: Int
        public let page: Int
        public let cards: [Card]
        
        // MARK: Filters
        
        public enum SortPriority: String {
            case manaCost
            case attack
            case health
            case name
            /// Sorts by class. Only recognized when searching constructed cards.
            case `class`
            /// Groups results by class. Only recognized when searching constructed cards.
            case groupByClass
            /// Sorts by tavern tier. Only recognized when searching Battlegrounds or Mercenaries cards.
            case tier
        }
        
        public enum SortOrder: String {
            case ascending = "asc"
            case descending = "desc"
        }
    }
    
    public struct CardBackSearch: Decodable {
        public let cardCount: Int
        public let pageCount: Int
        public let page: Int
        public let cardBacks: [CardBack]
        
        // MARK: Filters
        
        public enum SortPriority: String {
            /// Sorts by the date the card back was added.
            case date = "dateAdded"
            case name
        }
        
        public enum SortOrder: String {
            case ascending = "asc"
            case descending = "desc"
        }
    }
}
