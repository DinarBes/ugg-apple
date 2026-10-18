// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ugg-kit",
    platforms: [
        .iOS("16.4")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UggKit",
            targets: [
                "UggKitCore",
                "UggKitAuth",
                "UggKitSplash",
                "UggKitOnboarding",
                "UggKitHome",
                "UggKitProduct",
                "UggKitCart",
                "UggKitStores",
                "UggKitProfile",
                "UggKitNavigation",
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
        .onboarding(),
        .home(),
        .product(),
        .cart(),
        .stores(),
        .profile(),
        .navigation(),
        .uggKitDebugShared()
    ]
)

extension Package.Dependency {
    static func swinject() -> Package.Dependency {
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    }
}

extension Target {
    static func uggKitDebugShared() -> Target {
        .binaryTarget(
            name: "UggShared",
            path: "../../../multiplatform/ugg-client/shared/build/XCFrameworks/debug/UggShared.xcframework"
        )
    }

    static func core() -> Target {
        .target(
            name: "UggKitCore",
            dependencies: [
                "UggShared",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Core",
            // Brand fonts (registered at launch by `UggFonts.register()`) and the product photo.
            resources: [.process("Resources")]
        )
    }

    static func auth() -> Target {
        .target(
            name: "UggKitAuth",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Auth"
        )
    }

    static func splash() -> Target {
        .target(
            name: "UggKitSplash",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Splash"
        )
    }

    static func onboarding() -> Target {
        .target(
            name: "UggKitOnboarding",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Onboarding"
        )
    }

    static func home() -> Target {
        .target(
            name: "UggKitHome",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Home"
        )
    }

    static func product() -> Target {
        .target(
            name: "UggKitProduct",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Product"
        )
    }

    static func cart() -> Target {
        .target(
            name: "UggKitCart",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Cart"
        )
    }

    static func stores() -> Target {
        .target(
            name: "UggKitStores",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Stores"
        )
    }

    static func profile() -> Target {
        .target(
            name: "UggKitProfile",
            dependencies: [
                "UggShared",
                "UggKitCore",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Profile"
        )
    }

    static func navigation() -> Target {
        .target(
            name: "UggKitNavigation",
            dependencies: [
                "UggShared",
                "UggKitCore",
                "UggKitAuth",
                "UggKitSplash",
                "UggKitOnboarding",
                "UggKitHome",
                "UggKitProduct",
                "UggKitCart",
                "UggKitStores",
                "UggKitProfile",

                .product(name: "Swinject", package: "Swinject")
            ],
            path: "./Sources/Navigation"
        )
    }
}
