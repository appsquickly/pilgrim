// swift-tools-version:5.0
import PackageDescription

let package = Package(
	name: "Pilgrim-DI",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10)
    ],
	products: [
		.library(name: "PilgrimDI", targets: ["PilgrimDI"])
	],
	targets: [
		.target(
            name: "PilgrimDI",
            dependencies: [],
            path: "Pilgrim"
        ),
		.testTarget(
            name: "PilgrimDITests",
            dependencies: ["PilgrimDI"],
            path: "PilgrimTests"
        )
	],
    swiftLanguageVersions: [.v5]
)
