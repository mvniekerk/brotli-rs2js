import PackageDescription

let rustBuildDir = "../target/debug/"
let autoImportBrotliFfi = [
    "-Xfrontend", "-import-module", "-Xfrontend", "BrotliFfi"
]

let package = Package(
    name: "Brotli",
    products: [
        .library(
            name: "Brotli",
            targets: ["Brotli"]
        )
    ],
    dependencies: [],
    targets: [
        .systemLibrary(name: "BrotliFfi"),
        .target(
            name: "Brotli",
            dependencies: ["BrotliFfi"],
            exclude: ["Logging.m"],
            swiftSettings: [.unsafeFlags(autoImportBrotliFfi)]
        )
    ]
)
