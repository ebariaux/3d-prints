// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "painters-points",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/tomasf/Cadova.git", .upToNextMinor(from: "0.10.1"))
    ],
    targets: [
        .executableTarget(
            name: "painters-points",
            dependencies: ["Cadova"],
            swiftSettings: [.interoperabilityMode(.Cxx)]
        ),
    ]
)
