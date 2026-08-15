// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "CleanBRUH",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "CleanBRUH",
            path: "Sources/CleanBRUH"
        ),
        .testTarget(
            name: "CleanBRUHTests",
            dependencies: ["CleanBRUH"],
            path: "Tests/CleanBRUHTests"
        )
    ]
)
