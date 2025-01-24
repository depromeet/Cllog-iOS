//
//  Project.swift
//  Config
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

@preconcurrency import ProjectDescription

let project = Project(
    name: "AccountPresentation",
    targets: [
        .target(
            name: "AccountPresentation",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.CleanAppApp",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
//                .project(target: "AccountData", path: .relativeToRoot("Projects/Data/Account"))
                .project(target: "AccountDomain", path: .relativeToRoot("Projects/Domain/Account"))
            ]
        ),
        .target(
            name: "AccountPresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "AccountPresentation")]
        ),
    ]
)
