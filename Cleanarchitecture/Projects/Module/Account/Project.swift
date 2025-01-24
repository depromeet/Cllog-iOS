//
//  Project.swift
//  CleanArchitectureSampleAppManifests
//
//  Created by saeng lin on 1/23/25.
//

@preconcurrency import ProjectDescription

let project = Project(
    name: "Account",
    targets: [
        .target(
            name: "Account",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.CleanArchitectureSampleApp",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "AccountPresentation", path: .relativeToRoot("Projects/Presentation/Account")),
                .project(target: "AccountData", path: .relativeToRoot("Projects/Data/Account"))
                //
                //
                //
            ]
        ),
        .target(
            name: "AccountTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanArchitectureSampleAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Account")]
        ),
    ]
)
