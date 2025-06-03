// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DicyaninPlayground005",
    platforms: [
        .iOS(.v15),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "DicyaninPlayground005",
            targets: ["DicyaninPlayground005"]),
    ],
    dependencies: [
        .package(path: "Packages/DicyaninMultiDeviceMP")
    ],
    targets: [
        .target(
            name: "DicyaninPlayground005",
            dependencies: ["DicyaninMultiDeviceMP"]),
    ]
) 