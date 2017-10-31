// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MemoryLayoutKit",
    products: [
        .library(name: "MemoryLayoutKit", targets: ["MemoryLayoutKit"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "MemoryLayoutKit", dependencies: []),
        .testTarget(name: "MemoryLayoutKitTests", dependencies: ["MemoryLayoutKit"]),
    ]
)
