// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LNFileUtils",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LNFileUtils",
            targets: ["LNFileUtils"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sciasxp/SwiftQOI", from: "0.1.1"),
    ],
    targets: [
        .target(
            name: "LNFileUtils",
            dependencies: [.product(name: "SwiftQOI", package: "SwiftQOI")]
        ),
        .testTarget(
            name: "LNFileUtilsTests",
            dependencies: ["LNFileUtils"],
            resources: [.process("Assets")]
        ),
    ],
    swiftLanguageVersions: [.v5]
)

let version = Version("0.1.0")
