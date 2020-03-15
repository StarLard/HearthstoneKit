//
//  HSKitTestCase.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest

/// A wrapper around `XCTestCase` that provides additional utilities.
class HSKitTestCase: XCTestCase {
    func openSampleFile(_ file: SampleFile) -> Data {
        let url = Bundle(for: Self.self).url(forResource: file.rawValue, withExtension: "json")!
        return try! Data(contentsOf: url, options: .mappedIfSafe)
    }
    
    /// A wrapper around `XCTAssertNoThrow` that passes the result of the throwing call to a closure.
    func assertDoesNotThrow<Value>(_ expression: @autoclosure () throws -> Value, _ message: String = "",
                                       file: StaticString = #file, line: UInt = #line, onSuccess successHandler: (Value) -> Void) {
        func executeAndAssign(_ assignment: @autoclosure () throws -> Value, to assignable: inout Value?) rethrows {
            assignable = try assignment()
        }
        var value: Value?
        XCTAssertNoThrow(try executeAndAssign(expression, to: &value), message, file: file, line: line)
        if let value = value {
            successHandler(value)
        }
    }
}
