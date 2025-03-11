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
        .Features.Edit.feature,
        .Features.Calendar.feature,
        .Features.Folder.feature,
        .Features.FolderTab.feature,
        .Features.Video.feature,
        .Features.Login.feature,
        .Features.Main.feature,
        .Data.data(.cllog)
    ]
)
