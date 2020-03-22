//
//  APIRegions.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation

/// All requests to the Hearthstone API include a required region parameter. Regions are described in [Regionality and APIs](https://develop.battle.net/documentation/guides/regionality-and-apis).
public enum GameDataAPIRegion {
    case northAmerica
    case europe
    case korea
    case taiwan
    case china
    
    public var host: String {
        switch self {
        case .northAmerica: return "us.api.blizzard.com"
        case .europe: return "eu.api.blizzard.com"
        case .korea: return "kr.api.blizzard.com"
        case .taiwan: return "tw.api.blizzard.com"
        case .china: return "gateway.battlenet.com.cn"
        }
    }
}

/// All requests to the BattleNet Oauth API are specified by region. Regions are described in [Using and OAuth](https://develop.battle.net/documentation/guides/using-oauth).
public enum OAuthAPIRegion: String, Codable {
    case us
    case eu
    case apac
    case cn
    
    public var host: String {
        switch self {
        case .us: return "us.battle.net"
        case .eu: return "eu.battle.net"
        case .apac: return "apac.battle.net"
        case .cn: return "www.battlenet.com.cn"
        }
    }
}
