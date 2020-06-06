// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "EPSKit",
    products: [
        .library(
            name: "EPSKit",
            targets: ["EPSKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EPSKit",
            dependencies: []),
        .testTarget(
            name: "EPSKitTests",
            dependencies: ["EPSKit"]),
    ]
)
