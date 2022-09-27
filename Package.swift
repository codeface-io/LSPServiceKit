// swift-tools-version:5.6.0

import PackageDescription

let package = Package(
    name: "LSPServiceKit",
    platforms: [.iOS(.v11), .tvOS(.v11), .macOS(.v12)],
    products: [
        .library(
            name: "LSPServiceKit",
            targets: ["LSPServiceKit"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/codeface-io/SwiftLSP.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/flowtoolz/FoundationToolz.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/codeface-io/SwiftObserver.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/flowtoolz/SwiftyToolz.git",
            branch: "master"
        )
    ],
    targets: [
        .target(
            name: "LSPServiceKit",
            dependencies: ["SwiftLSP", "FoundationToolz", "SwiftObserver", "SwiftyToolz"],
            path: "Code"
        ),
        .testTarget(
            name: "LSPServiceKitTests",
            dependencies: ["LSPServiceKit"],
            path: "Tests"
        )
    ]
)
