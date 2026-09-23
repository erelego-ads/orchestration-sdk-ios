// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "Erelego",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Erelego", type: .static, targets: ["Erelego"])
    ],
    dependencies: [
        // Match the Google Mobile Ads version used to build ErelegoKit.
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            exact: "13.2.0"
        )
    ],
    targets: [
        .binaryTarget(name: "ErelegoKit", path: "Frameworks/ErelegoKit.xcframework"),
        .target(
            name: "Erelego",
            dependencies: [
                "ErelegoKit",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads")
            ],
            path: "Sources/Erelego",
            linkerSettings: [
                .linkedFramework("AdSupport"),
                .linkedFramework("AppTrackingTransparency"),
                .linkedFramework("WebKit")
            ]
        )
    ]
)
