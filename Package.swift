// swift-tools-version:5.0
import PackageDescription

let package = Package(
	name: "Pilgrim-DI",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10)
    ],
	products: [
		.library(name: "Pilgrim", targets: ["Pilgrim"])
	],
	targets: [
		.target(
            name: "Pilgrim",
            dependencies: [],
            path: "Pilgrim"
        ),
		.testTarget(
            name: "PilgrimTests",
            dependencies: ["Pilgrim"],
            path: "PilgrimTests"
        )
	],
    swiftLanguageVersions: [.v5]
)
