// swift-tools-version:5.4

import PackageDescription


let package = Package(
    name: "ApodiniCollector",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "ApodiniCollector",
            targets: ["ApodiniCollector"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Apodini/Apodini.git", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/Apodini/ApodiniAsyncHTTPClient.git", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/Apodini/Collector.git", .upToNextMinor(from: "0.1.0")),
    ],
    targets: [
        .target(
            name: "ApodiniCollector",
            dependencies: [
                .product(name: "Apodini", package: "Apodini"),
                .product(name: "ApodiniHTTP", package: "Apodini"),
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
