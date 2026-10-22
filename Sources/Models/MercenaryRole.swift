//
//  MercenaryRole.swift
//  HearthstoneKit
//

import Foundation

/// The role of a Mercenaries card, such as caster, fighter, or protector.
public struct MercenaryRole: Metadata, Identifiable {
    public let id: BlizzardIdentifier
    public let slug: String
    public let name: String
    public static let metadataKind: MetadataKind = .mercenaryRoles

    public init(id: BlizzardIdentifier, slug: String, name: String) {
        self.id = id
        self.slug = slug
        self.name = name
    }
}
