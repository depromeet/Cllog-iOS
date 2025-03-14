//
//  Project.swift
//  Config
//
//  Created by Junyoung Lee on 1/9/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Domain"),
    product: .staticFramework,
    dependencies: [
        .Domains.Folder.domain,
        .Domains.Calendar.domain,
        .Domains.Video.domain,
        .Domains.Login.domain,
    ]
)
