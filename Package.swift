// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReactiveRealmKit",
    products: [
        .library(
            name: "ReactiveRealmKit",
            targets: ["ReactiveRealmKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0")
    ],
    targets: [
        .target(
            name: "ReactiveRealmKit",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                "RxSwift"
            ]
        ),
        .testTarget(
            name: "ReactiveRealmKitTests",
            dependencies: ["ReactiveRealmKit"]
        )
    ]
)
