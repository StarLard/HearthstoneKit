//
//  ExpansionSet.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/23/20.
//

import Foundation

public struct ExpansionSet: Metadata {
    public let id: BlizzardIdentifier
    public let slug: String
    public let releaseDate: Date?
    public let name: String
    public let type: String?
    public let collectibleCount: Int
    public let collectibleRevealedCount: Int
    public let nonCollectibleCount: Int
    public let nonCollectibleRevealedCount: Int
    public static let metadataKind: MetadataKind = .sets
    
    enum CodingKeys: String, CodingKey {
        case id
        case releaseDate
        case type
        case name
        case slug
        case collectibleCount
        case collectibleRevealedCount
        case nonCollectibleCount
        case nonCollectibleRevealedCount
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(BlizzardIdentifier.self, forKey: .id)
        slug = try values.decode(String.self, forKey: .slug)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        collectibleCount = try values.decode(Int.self, forKey: .collectibleCount)
        collectibleRevealedCount = try values.decode(Int.self, forKey: .collectibleRevealedCount)
        nonCollectibleCount = try values.decode(Int.self, forKey: .nonCollectibleCount)
        nonCollectibleRevealedCount = try values.decode(Int.self, forKey: .nonCollectibleRevealedCount)
        if let dateString = try values.decodeIfPresent(String.self, forKey: .releaseDate) {
            guard let date = Self.APIDateFormatter().date(from: dateString) else {
                throw DecodingError.dataCorruptedError(forKey: .releaseDate, in: values, debugDescription: "Date string did not match expected format.")
            }
            releaseDate = date
        } else {
            releaseDate = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(slug, forKey: .slug)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encode(collectibleCount, forKey: .collectibleCount)
        try container.encode(collectibleRevealedCount, forKey: .collectibleRevealedCount)
        try container.encode(nonCollectibleCount, forKey: .nonCollectibleCount)
        try container.encode(nonCollectibleRevealedCount, forKey: .nonCollectibleRevealedCount)
        if let date = releaseDate {
            try container.encode(Self.APIDateFormatter().string(from: date), forKey: .releaseDate)
        }
    }
    
    static func APIDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: -21600) // Central Time
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
