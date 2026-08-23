// swift-tools-version: 6.2
/*-------------------------------------------------------------------------------------------------------------------------
     File: Package.swift
   Author: Kevin Messina
  Created: 8/21/26
 Modified: 08/23/2026 03:50 PM EDT
  Version: 2
   Source: CODEX: (GPT-5) 🤖AI Code a portion or all of this code.

©2026 Creative App Solutions, LLC. - All Rights Reserved.
--------------------------------------------------------------------------------------------------------------------------
NOTES:
-------------------------------------------------------------------------------------------------------------------------*/

import PackageDescription

let package = Package(
    name: "CAS-Compass",
    platforms: [
        .iOS(.v26),
        .macCatalyst(.v26),
        .macOS(.v26)
    ],
    products: [
        .library(
            name: "CASCompass",
            targets: ["CASCompass"]
        )
    ],
    targets: [
        .target(name: "CASCompass"),
        .testTarget(
            name: "CASCompassTests",
            dependencies: ["CASCompass"]
        )
    ],
    swiftLanguageModes: [.v5]
)
