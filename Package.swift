// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MetopiaARCreatorCommon",
  platforms: [
    .iOS(.v13),
    .macOS(.v12),
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "MetopiaARCreatorCommon",
      targets: ["MetopiaARCreatorCommon"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/supabase/supabase-swift.git", .upToNextMajor(from: "0.0.0")),
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "MetopiaARCreatorCommon",
      dependencies: [
        .product(name: "Supabase", package: "supabase-swift"),
        .product(name: "Alamofire", package: "Alamofire"),
      ]
    ),
    .testTarget(
      name: "MetopiaARCreatorCommonTests",
      dependencies: ["MetopiaARCreatorCommon"]
    ),
  ]
)
