//
//  Networking.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import Combine

extension URLSession.DataTaskPublisher {
    func tryExtractData() -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        return tryMap({ (data: Data, response: URLResponse) -> Data in
            guard let response = response as? HTTPURLResponse else {
                throw HearthstoneAPI.ServiceError.noResponse
            }
            guard response.statusCode == 200 else {
                throw HearthstoneAPI.ServiceError.invalidStatus(response.statusCode)
            }
            if let underlyingError = try? JSONDecoder().decode(HearthstoneAPI.ServiceError.self, from: data) {
                throw underlyingError
            }
            return data
        })
    }
}
