//
//  BattleNetUserInfo.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/21/20.
//

import Foundation

public struct BattleNetUserInfo: Codable, Hashable, Identifiable, Sendable {
    public let id: Int
    public let battletag: String
    
    public init(id: Int, battletag: String) {
        self.id = id
        self.battletag = battletag
    }
}
