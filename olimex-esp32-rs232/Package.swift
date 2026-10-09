// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "olimex",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "1.0.0"))
    ],
    targets: [
        .executableTarget(
            name: "olimex",
            dependencies: ["Cadova"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
