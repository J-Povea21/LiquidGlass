// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DomainKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "DomainKit", targets: ["DomainKit"]),
    ],
    targets: [
        .target(
            name: "DomainKit",
            path: "Sources/DomainKit"
        ),
        .testTarget(
            name: "DomainKitTests",
            dependencies: ["DomainKit"],
            path: "Tests/DomainKitTests"
        ),
    ]
)
