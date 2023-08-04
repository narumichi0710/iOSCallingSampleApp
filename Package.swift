// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSCallingSampleApp",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: .init(10, 13, 0)),
    ], targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),
    ]
)
