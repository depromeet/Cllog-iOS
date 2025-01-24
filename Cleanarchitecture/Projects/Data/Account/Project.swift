//
//  Project.swift
//  Config
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

@preconcurrency import ProjectDescription

let project = Project(
    name: "AccountData",
    targets: [
        .target(
            name: "AccountData",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.CleanAppApp",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "AccountDomain", path: .relativeToRoot("Projects/Domain/Account"))
            ]
        ),
        .target(
            name: "AccountDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "AccountData")]
        ),
    ]
)
