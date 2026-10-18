// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "template-kit",
    platforms: [
        .iOS("16.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TemplateKit",
            targets: [
                "TemplateKitCore",
                "TemplateKitAuth",
                "TemplateKitSplash",
                "TemplateKitNavigation",
            ]
        ),
    ],
    dependencies: [
        .swinject(),
    ],
    targets: [
        .core(),
        .auth(),
        .splash(),
        .navigation(),
        .templateDebugShared()
    ]
)

extension Package.Dependency {
    static func swinject() -> Package.Dependency {
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    }
}

extension Target {
    static func templateDebugShared() -> Target {
        .binaryTarget(
            name: "TemplateShared",
            path: "../../../multiplatform/template-client/shared/build/XCFrameworks/debug/TemplateShared.xcframework"
        )
    }

    static func core() -> Target {
        .target(
            name: "TemplateKitCore",
            dependencies: [
                "TemplateShared",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Core"
        )
    }

    static func auth() -> Target {
        .target(
            name: "TemplateKitAuth",
            dependencies: [
                "TemplateShared",
                "TemplateKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Auth"
        )
    }

    static func splash() -> Target {
        .target(
            name: "TemplateKitSplash",
            dependencies: [
                "TemplateShared",
                "TemplateKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Splash"
        )
    }

    static func navigation() -> Target {
        .target(
            name: "TemplateKitNavigation",
            dependencies: [
                "TemplateShared",
                "TemplateKitCore",
                "TemplateKitAuth",
                "TemplateKitSplash",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Navigation"
        )
    }
}
