//
//  HSKLog.swift
//  HearthstoneKit
//
//  Created by Caleb Friden on 3/13/20.
//

import Foundation
import os.log

enum HSKLog {
    private static let log = OSLog(subsystem: "com.calebfriden.hearthstone-kit", category: "HearthstoneKit")
    
    /// Logs a message to the system log and includes debugging details such as file, line number, etc.
    @inlinable @inline(__always)
    public static func log(_ type: OSLogType, _ message : String, dso: UnsafeRawPointer = #dsohandle, function: String = #function, file: String = #file, line: UInt = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(fileName):\(line)] \(function) - \(message)"
        os_log("%{public}@", dso: dso, log: Self.log, type: type, logMessage)
    }
}
