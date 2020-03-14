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
