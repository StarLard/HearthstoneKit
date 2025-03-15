//
//  PlayerLocale.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// All requests in the Hearthstone API include an optional locale parameter. Localization works as described in [Hearthstone Localization ](https://develop.battle.net/documentation/hearthstone/guides/localization).
public enum PlayerLocale: String, CaseIterable, Codable {
    /// German - Germany
    case deDE = "de_DE"
    /// English - United States
    case enUS = "en_US"
    /// Spanish - Spain
    case esES = "es_ES"
    /// Spanish - Mexico
    case esMX = "es_MX"
    /// French - France
    case frFR = "fr_FR"
    /// Italian - Italy
    case itIT = "it_IT"
    /// Japanese - Japan
    case jaJP = "ja_JP"
    /// Korean - Korea
    case koKR = "ko_KR"
    /// Polish - Poland
    case plPL = "pl_PL"
    /// Portuguese - Brazil
    case ptBR = "pt_BR"
    /// Russian - Russian Federation
    case ruRU = "ru_RU"
    /// Thai - Thailand
    case thTH = "th_TH"
    /// Chinese - Taiwan
    case zhTW = "zh_TW"
    
    /// The `PlayerLocale` associated with the locale returned from `Locale.autoupdatingCurrent` or `nil`
    /// if the locale is unsupported.
    public static var current: PlayerLocale? { Self.init(locale: .autoupdatingCurrent) }
    
    public init?(locale: Locale) {
        switch locale.identifier {
        case "de_DE": self = .deDE
        case "en_US": self = .enUS
        case "es_ES": self = .esES
        case "es_MX": self = .esMX
        case "fr_FR": self = .frFR
        case "it_IT": self = .itIT
        case "ja_JP": self = .jaJP
        case "ko_KR": self = .koKR
        case "pl_PL": self = .plPL
        case "pt_BR": self = .ptBR
        case "ru_RU": self = .ruRU
        case "th_TH": self = .thTH
        case "zh_Hant_TW": self = .zhTW
        default: return nil
        }
    }
    
    public var locale: Locale {
        let localeID: String
        switch self {
        case .deDE: localeID = "de_DE"
        case .enUS: localeID = "en_US"
        case .esES: localeID = "es_ES"
        case .esMX: localeID = "es_MX"
        case .frFR: localeID = "fr_FR"
        case .itIT: localeID = "it_IT"
        case .jaJP: localeID = "ja_JP"
        case .koKR: localeID = "ko_KR"
        case .plPL: localeID = "pl_PL"
        case .ptBR: localeID = "pt_BR"
        case .ruRU: localeID = "ru_RU"
        case .thTH: localeID = "th_TH"
        case .zhTW: localeID = "zh_Hant_TW"
        }
        return Locale(identifier: localeID)
    }
    
    public var gameDataAPIRegion: GameDataAPIRegion {
        switch self {
        case .enUS, .esMX, .ptBR: return .northAmerica
        case .esES, .frFR, .ruRU, .deDE, .itIT, .plPL: return .europe
        case .koKR, .jaJP, .thTH: return .korea
        case .zhTW: return .taiwan
        }
    }
    
    public var oauthAPIRegion: OAuthAPIRegion {
        switch self {
        case .enUS, .esMX, .ptBR: return .us
        case .esES, .frFR, .ruRU, .deDE, .itIT, .plPL: return .eu
        case .koKR, .jaJP, .thTH, .zhTW: return .apac
        }
    }
    
    public var localizedName: String {
        switch self {
        case .deDE: return "Germany"
        case .enUS: return "United States"
        case .esES: return "España"
        case .esMX: return "Mexico"
        case .frFR: return "France"
        case .itIT: return "Italia"
        case .jaJP: return "日本"
        case .koKR: return "대한민국"
        case .plPL: return "Polska"
        case .ptBR: return "Brasil"
        case .ruRU: return "Россия"
        case .thTH: return "ประเทศไทย"
        case .zhTW: return "台灣"
        }
    }
}
