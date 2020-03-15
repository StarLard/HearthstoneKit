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
        }
        
        public enum SortOrder: String {
            case ascending = "asc"
            case descending = "desc"
        }
    }
}
