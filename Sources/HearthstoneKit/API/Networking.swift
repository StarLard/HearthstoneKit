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
                throw APIServiceError.noResponse
            }
            guard response.statusCode == 200 else {
                throw APIServiceError.invalidStatus(response.statusCode)
            }
            if let underlyingError = try? JSONDecoder().decode(APIServiceError.self, from: data) {
                throw underlyingError
            }
            return data
        })
    }
}
