//
//  Oauth.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Combine

extension HearthstoneAPI {
    typealias AccessToken = String
    
    static func fetchAccessTokenIfNeeded() -> AnyPublisher<AccessToken, Error> {
        // TODO
    }
}
