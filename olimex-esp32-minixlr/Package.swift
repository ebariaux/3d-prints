// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "olimex",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "0.3.3")),
        .package(url: "https://github.com/tomasf/Helical.git", .upToNextMajor(from: "0.4.1")),
    ],
    targets: [
        .executableTarget(
            name: "olimex",
            dependencies: ["Cadova", "Helical"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
