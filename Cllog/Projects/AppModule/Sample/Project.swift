//
//  Project.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .app,
    product: .app,
    dependencies: [
        .Modules.umbrella
    ]
)
