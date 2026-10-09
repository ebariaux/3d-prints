// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "olimex",
    platforms: [.macOS(.v15)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/tomasf/Helical.git", .upToNextMajor(from: "1.1.0")),
    ],
    targets: [
        .executableTarget(
            name: "olimex",
            dependencies: ["Cadova", "Helical"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
