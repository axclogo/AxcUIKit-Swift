// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "AxcUIKit",
    defaultLocalization: "zh-Hans",
    platforms: [
        .iOS(.v12),
        .macOS(.v11)
    ],
    products: [
        .library(name: "AxcUIKit", targets: ["AxcUIKit"]),
        .library(name: "AxcUIKitCore", targets: ["AxcUIKitCore"]),
        .library(name: "AxcUIKitGradient", targets: ["AxcUIKitGradient"]),
        .library(name: "AxcUIKitLabel", targets: ["AxcUIKitLabel"]),
        .library(name: "AxcUIKitBubble", targets: ["AxcUIKitBubble"]),
        .library(name: "AxcUIKitTable", targets: ["AxcUIKitTable"]),
        .library(name: "AxcUIKitCollection", targets: ["AxcUIKitCollection"]),
        .library(name: "AxcUIKitButton", targets: ["AxcUIKitButton"]),
        .library(name: "AxcUIKitImage", targets: ["AxcUIKitImage"]),
        .library(name: "AxcUIKitScroll", targets: ["AxcUIKitScroll"]),
        .library(name: "AxcUIKitStack", targets: ["AxcUIKitStack"]),
        .library(name: "AxcUIKitAppKit", targets: ["AxcUIKitAppKit"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/axclogo/AxcBedrock-Swift.git",
            revision: "8a8e1c5e906e30770425102632c7dfa718744bd0"
        ),
        .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            exact: "5.7.1"
        )
    ],
    targets: [
        .target(
            name: "AxcUIKitCore",
            dependencies: [
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift")
            ],
            path: "AxcUIKit/Classes/Core",
            exclude: ["README.md", "Layer/README.md", "View/README.md", "ViewController/README.md"]
        ),
        .target(
            name: "AxcUIKitGradient",
            dependencies: [
                "AxcUIKitCore",
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift")
            ],
            path: "AxcUIKit/Classes/Gradient",
            exclude: ["README.md", "GradientLayer/README.md", "GradientView/README.md"]
        ),
        .target(
            name: "AxcUIKitLabel",
            dependencies: [
                "AxcUIKitCore",
                "AxcUIKitGradient",
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "AxcUIKit/Classes/Label",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitBubble",
            dependencies: [
                "AxcUIKitCore",
                "AxcUIKitGradient",
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "AxcUIKit/Classes/Bubble",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitTable",
            dependencies: [
                "AxcUIKitCore",
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift")
            ],
            path: "AxcUIKit/Classes/Table",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitCollection",
            path: "AxcUIKit/Classes/Collection",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitButton",
            path: "AxcUIKit/Classes/Button",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitImage",
            dependencies: [
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift")
            ],
            path: "AxcUIKit/Classes/Image",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitScroll",
            dependencies: ["AxcUIKitCore"],
            path: "AxcUIKit/Classes/Scroll",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitStack",
            path: "AxcUIKit/Classes/Stack",
            exclude: ["README.md"]
        ),
        .target(
            name: "AxcUIKitAppKit",
            dependencies: [
                "AxcUIKitCore",
                .product(name: "AxcBedrock", package: "AxcBedrock-Swift"),
                .product(name: "SnapKit", package: "SnapKit")
            ],
            path: "AxcUIKit/Classes/AppKit",
            exclude: ["README.md", "ConsoleView/README.md", "TargetDragView/README.md"]
        ),
        .target(
            name: "AxcUIKit",
            dependencies: [
                "AxcUIKitCore",
                "AxcUIKitGradient",
                "AxcUIKitLabel",
                "AxcUIKitBubble",
                "AxcUIKitTable",
                "AxcUIKitCollection",
                "AxcUIKitButton",
                "AxcUIKitImage",
                "AxcUIKitScroll",
                "AxcUIKitStack",
                .target(name: "AxcUIKitAppKit", condition: .when(platforms: [.macOS]))
            ],
            path: "AxcUIKit/Umbrella"
        ),
        .testTarget(
            name: "AxcUIKitTests",
            dependencies: [
                "AxcUIKitCore",
                "AxcUIKitGradient",
                "AxcUIKitLabel",
                "AxcUIKitBubble",
                "AxcUIKitTable",
                "AxcUIKitCollection",
                "AxcUIKitButton",
                "AxcUIKitImage",
                "AxcUIKitScroll",
                "AxcUIKitStack",
                "AxcUIKitAppKit"
            ],
            path: "Tests/AxcUIKitTests"
        )
    ],
    swiftLanguageVersions: [.v5]
)
