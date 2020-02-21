//
//  PlayerLocale.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 2/20/20.
//

import Foundation

/// All requests in the Hearthstone API include an optional locale parameter. Localization works as described in [Regionality and APIs](https://develop.battle.net/documentation/guides/regionality-and-apis).
public enum BattleNetRegion: String, CaseIterable {
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
}
