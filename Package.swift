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
            exact: "0.3.8"
        ),
        .package(
            url: "https://github.com/flowtoolz/FoundationToolz.git",
            exact: "0.1.7"
        ),
        .package(
            url: "https://github.com/codeface-io/SwiftObserver.git",
            exact: "7.0.6"
        ),
        .package(
            url: "https://github.com/flowtoolz/SwiftyToolz.git",
            exact: "0.3.0"
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
            dependencies: ["LSPServiceKit", "SwiftLSP"],
            path: "Tests"
        )
    ]
)
