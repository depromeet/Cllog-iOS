// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
import ProjectDescription
import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [
            "SnapKit": .framework,
            "Alamofire": .framework,
            "Then": .framework,
            "Pulse": .framework,
            "Swinject": .framework
        ],
        baseSettings: Settings.settings(configurations: XCConfig.framework)
    )
#endif

let package = Package(
    name: "TestProject",
    platforms: [.iOS(.v16)],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.7.1"),
        .package(url: "https://github.com/devxoul/Then.git", exact: "3.0.0"),
        .package(url: "https://github.com/kean/Pulse.git", exact: "5.1.2"),
        .package(url: "https://github.com/Swinject/Swinject.git", exact: "2.9.1")
    ]
)
