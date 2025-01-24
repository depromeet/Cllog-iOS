//
//  Project.swift
//  CleanArchitectureSampleAppManifests
//
//  Created by saeng lin on 1/23/25.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "CleanApp",
    targets: [
        .target(
            name: "CleanApp",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.CleanrchitectureApps",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
                .project(target: "Umbrella", path: .relativeToRoot("Projects/Module/Umbrella"))
                
                //
//                TargetDependency.project(target: "DepremeetService", path: .relativeToRoot("Projects/Service/Depromeet"))
            ]
        ),
        .target(
            name: "CleanAppTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanrchitectureAppsTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "CleanApp")]
        ),
    ]
)
