// swift-tools-version: 5.9
// JobWorldQueue - 잡월드 체험 최적 루트 iOS 앱

import PackageDescription

let package = Package(
    name: "JobWorldQueue",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "JobWorldQueue",
            targets: ["JobWorldQueue"]
        )
    ],
    targets: [
        .target(
            name: "JobWorldQueue",
            path: "Sources/JobWorldQueue",
            resources: [
                .copy("PrivacyInfo.xcprivacy"),
                .process("Assets.xcassets")
            ]
        ),
        .testTarget(
            name: "JobWorldQueueTests",
            dependencies: ["JobWorldQueue"],
            path: "Tests/JobWorldQueueTests"
        )
    ]
)
