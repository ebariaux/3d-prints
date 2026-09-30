// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "table-tags",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "0.10.2")),
    ],
    targets: [
        .executableTarget(
            name: "table-tags",
            dependencies: ["Cadova"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
