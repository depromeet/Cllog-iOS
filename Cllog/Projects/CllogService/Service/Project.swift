//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/24/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .service(name: "Cllog"),
    product: .staticFramework,
    dependencies: [
        .Features.Calendar.feature,
        .Features.Folder.feature,
        .Features.FolderTab.feature,
        .Features.Capture.feature,
        .Features.Login.feature,
        .Features.Main.feature,
        .Data.data(.cllog)
    ]
)
