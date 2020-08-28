//
//  Error.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation

/// An error thrown when problems occur with one of the APIs.
public struct APIServiceError: CustomNSError, Decodable {
    public static let errorDomain: String = "HearthstoneKit.APIServiceError"
    
    static var noResponse: APIServiceError {
        APIServiceError(status: 204, statusMessage: "Bad Response", message: "The API response was empty.")
    }
    
    static func invalidStatus(_ status: Int) -> APIServiceError {
        APIServiceError(status: status, statusMessage: "Bad Response", message: "The status code recieved from the API was not valid.")
    }
    
    public let status: Int
    public let statusMessage: String
    public let message: String
            
    public var errorUserInfo: [String: Any] {
        return ["status": status, "statusMessage": statusMessage, "message": message]
    }
}
