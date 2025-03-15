//
//  Networking.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation

extension URLSession {
    func value<T>(_ type: T.Type, for request: URLRequest, using decoder: JSONDecoder) async throws -> T where T : Decodable {
        let (data, response) = try await data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw APIServiceError.noResponse
        }
        guard response.statusCode == 200 else {
            throw APIServiceError.invalidStatus(response.statusCode)
        }
        if let underlyingError = try? decoder.decode(APIServiceError.self, from: data) {
            throw underlyingError
        }
        return try decoder.decode(T.self, from: data)
    }
}
