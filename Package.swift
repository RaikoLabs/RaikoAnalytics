// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "RaikoAnalytics",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "RaikoAnalytics", targets: ["RaikoAnalytics"])
    ],
    targets: [
        .target(name: "RaikoAnalytics")
    ]
)
