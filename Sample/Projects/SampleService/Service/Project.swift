//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/24/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .service(name: "Sample"),
    product: .staticFramework,
    dependencies: [
        .Features.Main.feature,
        .Modules.data(.sample)
    ]
)
