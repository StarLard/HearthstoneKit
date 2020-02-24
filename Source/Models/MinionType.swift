//
//  MinionType.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct MinionType: Codable, Hashable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
}
