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
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", exact:.init(10, 9, 0)),
    ], targets: [
        .target(
            name: "iOSCallingSampleApp"),
        .testTarget(
            name: "iOSCallingSampleAppTests",
            dependencies: [
                "iOSCallingSampleApp",
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
            ]),
    ]
)
