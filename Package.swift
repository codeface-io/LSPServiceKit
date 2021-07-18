// swift-tools-version:5.4.0

import PackageDescription

let package = Package(
    name: "LSPServiceAPI",
    platforms: [.iOS(.v11), .tvOS(.v11), .macOS(.v10_15)],
    products: [
        .library(
            name: "LSPServiceAPI",
            targets: ["LSPServiceAPI"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/flowtoolz/SwiftLSP.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/flowtoolz/FoundationToolz.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/flowtoolz/SwiftObserver.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/flowtoolz/SwiftyToolz.git",
            .branch("master")
        ),
    ],
    targets: [
        .target(
            name: "LSPServiceAPI",
            dependencies: ["SwiftLSP", "FoundationToolz", "SwiftObserver", "SwiftyToolz"],
            path: "Code"
        ),
    ]
)
