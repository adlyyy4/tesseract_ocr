// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "flutter_tesseract_ocr",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "flutter-tesseract-ocr", targets: ["flutter_tesseract_ocr"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // SwiftyTesseract 4.x is the first (and last) version published as a Swift package. It and its
        // binary dependency libtesseract were archived in April 2022, so pin exactly rather than
        // leaving a range that can never resolve to anything newer.
        .package(url: "https://github.com/SwiftyTesseract/SwiftyTesseract.git", exact: "4.0.1")
    ],
    targets: [
        .target(
            name: "flutter_tesseract_ocr",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "SwiftyTesseract", package: "SwiftyTesseract")
            ]
        )
    ]
)
