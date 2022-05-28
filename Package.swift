// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pilgrim",
    platforms: [
        .iOS(.v14), .macOS(.v11), .tvOS(.v9),
        .macCatalyst(.v13), .watchOS(.v2), .driverKit(.v19)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PilgrimDI",
            targets: ["Pilgrim"]
        ),
    ],
    dependencies: [],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Pilgrim",
            dependencies: []),
        .testTarget(
            name: "PilgrimTests",
            dependencies: ["Pilgrim"]),
    ]
)
