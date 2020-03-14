//
//  Error.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/10/20.
//

import Foundation

extension HearthstoneAPI {
    /// An error thrown when problems occur with the Hearthstone API.
    public struct ServiceError: CustomNSError, Decodable {
        public static let errorDomain: String = "HearthstoneAPI.ServiceError"
        
        static var noResponse: ServiceError {
            ServiceError(status: 204, statusMessage: "Bad Response", message: "The API response was empty.")
        }
        
        static func invalidStatus(_ status: Int) -> ServiceError {
            ServiceError(status: status, statusMessage: "Bad Response", message: "The status code recieved from the API was not valid.")
        }
        
        public let status: Int
        public let statusMessage: String
        public let message: String
                
        public var errorUserInfo: [String: Any] {
            return ["status": status, "statusMessage": statusMessage, "message": message]
        }
    }
}
