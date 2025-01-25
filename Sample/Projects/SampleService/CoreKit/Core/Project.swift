//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/10/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "Core"),
    product: .staticFramework,
    dependencies: [
        .Core.designKit(.sample),
        .Domains.Domain.domain,
    ]
)
