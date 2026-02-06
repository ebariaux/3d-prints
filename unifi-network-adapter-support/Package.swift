// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "unifi-support",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "0.5.1")),
    ],
    targets: [
        .executableTarget(
            name: "unifi-support",
            dependencies: ["Cadova"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
