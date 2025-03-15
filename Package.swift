// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "HearthstoneKit",
    platforms: [ .iOS(.v15), .macOS(.v11), .tvOS(.v14), .watchOS(.v7) ],
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
