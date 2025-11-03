// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VaecebyzCapacitorAmap",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "VaecebyzCapacitorAmap",
            targets: ["AmapPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "AmapPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/AmapPlugin"),
        .testTarget(
            name: "AmapPluginTests",
            dependencies: ["AmapPlugin"],
            path: "ios/Tests/AmapPluginTests")
    ]
)