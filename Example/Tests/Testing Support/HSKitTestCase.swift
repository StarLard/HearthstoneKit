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
}
