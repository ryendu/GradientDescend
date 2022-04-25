// swift-tools-version: 5.5

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "GradientDescend",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "GradientDescend",
            targets: ["AppModule"],
            bundleIdentifier: "com.ryandu.gradient-descend",
            teamIdentifier: "95566VVRBB",
            displayVersion: "1.0",
            bundleVersion: "1",
            iconAssetName: "AppIcon",
            accentColorAssetName: "AccentColor",
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .landscapeRight,
                .landscapeLeft
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources/intro.m4a"),
                .process("Resources/simple3dgd.scn"),

            ]
        )
    ]
)
