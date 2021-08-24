// swift-tools-version:5.5

//
// This source file is part of the Apodini Collector open source project
//
// SPDX-FileCopyrightText: 2021 Paul Schmiedmayer and the project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "ApodiniCollector",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "ApodiniCollector",
            targets: ["ApodiniCollector"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/Apodini.git", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/Apodini/ApodiniAsyncHTTPClient.git", .upToNextMinor(from: "0.3.1")),
        .package(url: "https://github.com/Apodini/Collector.git", .upToNextMinor(from: "0.1.0"))
    ],
    targets: [
        .target(
            name: "ApodiniCollector",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniHTTPProtocol", package: "Apodini"),
                .product(name: "ApodiniAsyncHTTPClient", package: "ApodiniAsyncHTTPClient"),
                .product(name: "Collector", package: "Collector"),
                .product(name: "JaegerCollector", package: "Collector"),
                .product(name: "PrometheusCollector", package: "Collector")
            ]
        ),
        .testTarget(
            name: "ApodiniCollectorTests",
            dependencies: [
                .target(name: "ApodiniCollector")
            ]
        )
    ]
)
