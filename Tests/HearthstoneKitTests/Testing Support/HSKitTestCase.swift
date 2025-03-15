//
//  HSKitTestCase.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
@testable import HearthstoneKit

/// A wrapper around `XCTestCase` that provides additional utilities.
class HSKitTestCase: XCTestCase {
    @MainActor private static var hasConfiguredSDK = false
    private static var testingConfiguration: HearthstoneKit.Configuration { HearthstoneKit.Configuration(bundle: Bundle.module)! }
    
    class override func setUp() {
        super.setUp()
        onMain {
            if !hasConfiguredSDK {
                HearthstoneKit.configure(with: testingConfiguration)
                hasConfiguredSDK = true
            }
        }
    }
    
    func openSampleFile(_ file: SampleFile) -> Data {
        let url = Bundle.module.url(forResource: file.rawValue, withExtension: "json")!
        return try! Data(contentsOf: url, options: .mappedIfSafe)
    }
    
    /// A wrapper around `XCTAssertNoThrow` that passes the result of the throwing call to a closure.
    func assertDoesNotThrow<Value>(_ expression: @autoclosure () throws -> Value, _ message: String = "",
                                   file: StaticString = #filePath, line: UInt = #line, onSuccess successHandler: (Value) -> Void) {
        func executeAndAssign(_ assignment: @autoclosure () throws -> Value, to assignable: inout Value?) rethrows {
            assignable = try assignment()
        }
        var value: Value?
        XCTAssertNoThrow(try executeAndAssign(expression(), to: &value), message, file: file, line: line)
        if let value = value {
            successHandler(value)
        }
    }
}

private func onMain(_ block: @MainActor () -> Void) {
    if Thread.isMainThread {
        MainActor.assumeIsolated {
            block()
        }
    } else {
        DispatchQueue.main.sync {
            MainActor.assumeIsolated {
                block()
            }
        }
    }
}
