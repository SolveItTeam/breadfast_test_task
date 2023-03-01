// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS("14.0")],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        )
    ],
    dependencies: [
        .package(name: "DomainLayer", path: "../DomainLayer"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1"))
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                .product(
                    name: "DomainLayer",
                    package: "DomainLayer",
                    condition: .when(platforms: [.iOS])
                ),
                .product(
                    name: "Alamofire",
                    package: "Alamofire",
                    condition: .when(platforms: [.iOS])
                )
            ]
        )
    ]
)
