// swift-tools-version:6.4

import PackageDescription

let package = Package(
    name: "HearthstoneKit",
    platforms: [ .iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v9) ],
    products: [
        .library(
            name: "HearthstoneKit",
            targets: ["HearthstoneKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HearthstoneKit",
            dependencies: []
        ),
        .testTarget(
            name: "HearthstoneKitTests",
            dependencies: ["HearthstoneKit"],
            resources: [.process("Resources")]
        ),
    ]
)
