// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MarkdownReader",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MarkdownReader", targets: ["MarkdownReader"])
    ],
    dependencies: [
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.4.1")
    ],
    targets: [
        .executableTarget(
            name: "MarkdownReader",
            dependencies: [
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ]
        )
    ]
)
