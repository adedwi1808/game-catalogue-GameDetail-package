// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GameDetail",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "GameDetail", targets: ["GameDetail"]),
    ],
    dependencies: [
        .package(url: "https://github.com/adedwi1808/game-catalogue-Core-package.git", from: "1.0.0"),
.package(url: "https://github.com/adedwi1808/game-catalogue-Common-package.git", from: "1.0.0"),
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            from: "8.0.0"
        ),
    ],
    targets: [
        .target(
            name: "GameDetail",
            dependencies: ["Core", "Common", "Kingfisher"]
        ),
    ]
)
