// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSCallingSampleApp",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "iOSCallingSampleApp",
            targets: ["iOSCallingSampleApp"]),
    ],
    targets: [
        .target(
            name: "iOSCallingSampleApp"),
        .testTarget(
            name: "iOSCallingSampleAppTests",
            dependencies: ["iOSCallingSampleApp"]),
    ]
)
