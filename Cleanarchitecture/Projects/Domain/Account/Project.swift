//
//  Project.swift
//  Config
//
//  Created by saeng lin on 1/24/25.
//

import Foundation

@preconcurrency import ProjectDescription

let project = Project(
    name: "AccountDomain",
    targets: [
        .target(
            name: "AccountDomain",
            destinations: .iOS,
            product: .staticFramework,
            bundleId: "io.tuist.CleanAppApp",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                
            ]
        ),
        .target(
            name: "AccountDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.CleanAppTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "AccountDomain")]
        ),
    ]
)
