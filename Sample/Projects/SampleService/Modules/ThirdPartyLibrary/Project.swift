//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "ThirdPartyLibrary"),
    product: .staticFramework,
    dependencies: [
        .Library.then
    ]
)
