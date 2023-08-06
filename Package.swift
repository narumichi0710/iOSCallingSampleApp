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
        .library(
            name: "Service",
            targets: ["Service"]
        ),
        .library(
            name: "Repository",
            targets: ["Repository"]
        ),
        .library(
            name: "Network",
            targets: ["Network"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: .init(10, 13, 0)),
    ], targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Service",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
            ]
        ),
        .target(
            name: "Service",
            dependencies: [
                "Repository"
            ],
            path: "Sources/Core/Service"
        ),
        .target(
            name: "Repository",
            dependencies: [
                "Network"
            ],
            path: "Sources/Core/Repository"
        ),
        .target(
            name: "Network",
            dependencies: [],
            path: "Sources/Core/Network"
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature"]
        ),
        
    ]
)
