//
//  APIRegion.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation

/// All requests to the Hearthstone API include a required region parameter. Regions are described in [Regionality and APIs](https://develop.battle.net/documentation/guides/regionality-and-apis).
public enum APIRegion {
    case northAmerica
    case europe
    case korea
    case taiwan
    case china
    
    public var host: URL {
        switch self {
        case .northAmerica: return URL(string: "https://us.api.blizzard.com/")!
        case .europe: return URL(string: "https://eu.api.blizzard.com/")!
        case .korea: return URL(string: "https://kr.api.blizzard.com/")!
        case .taiwan: return URL(string: "https://tw.api.blizzard.com/")!
        case .china: return URL(string: "https://gateway.battlenet.com.cn/")!
        }
    }
}
