//
//  TestSupport.swift
//  HearthstoneKit_Tests
//
//  Created by Caleb Friden on 2/20/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Testing
@testable import HearthstoneKit

/// Parent suite for tests that hit the live API. They share the keychain-cached access token, so they run one at a time.
@Suite(.serialized)
struct LiveAPITests {}

@MainActor private var hasConfiguredSDK = false

/// Configures HearthstoneKit with the testing credentials. Safe to call from every suite that hits the network,
/// since `HearthstoneKit.configure(with:)` may only be called once per process.
@MainActor func configureSDKIfNeeded() throws {
    guard !hasConfiguredSDK else { return }
    // The plist holds real API credentials, so it isn't checked in. Live tests fail without it rather than silently skipping.
    let configuration = try #require(
        HearthstoneKit.Configuration(bundle: Bundle.module),
        "Missing or invalid HearthstoneKit-Configuration.plist. Copy HearthstoneKit-Configuration.example.plist in Tests/HearthstoneKitTests/Resources and add your Blizzard API credentials."
    )
    HearthstoneKit.configure(with: configuration)
    hasConfiguredSDK = true
}

func openSampleFile(_ file: SampleFile) throws -> Data {
    let url = try #require(Bundle.module.url(forResource: file.rawValue, withExtension: "json"))
    return try Data(contentsOf: url, options: .mappedIfSafe)
}
