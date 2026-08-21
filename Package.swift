// swift-tools-version: 6.2
/*-------------------------------------------------------------------------------------------------------------------------
     File: Package.swift
   Author: Kevin Messina
  Created: 8/21/26
 Modified: 08/21/2026 05:45 PM EDT
  Version: 1
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
        .macCatalyst(.v26)
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
