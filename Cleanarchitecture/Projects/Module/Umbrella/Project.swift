//
//  Project.swift
//  Config
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

@preconcurrency import ProjectDescription

let project = Project(
    name: "Umbrella",
    targets: [
        .target(
            name: "Umbrella",
            destinations: .iOS,
            product: .framework,
            bundleId: "io.tuist.Umbrella",
            sources: [],
            resources: [],
            dependencies: [
                .project(target: "Account", path: .relativeToRoot("Projects/Module/Account"))
                
            ]
        ),
    ]
)
