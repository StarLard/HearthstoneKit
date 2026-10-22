//
//  SpellSchool.swift
//  HearthstoneKit
//

import Foundation

/// The school of a spell card, such as arcane, fire, or frost.
public struct SpellSchool: Metadata, Identifiable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
    public static let metadataKind: MetadataKind = .spellSchools

    public init(id: BlizzardIdentifier, slug: String, name: String) {
        self.id = id
        self.slug = slug
        self.name = name
    }
}
