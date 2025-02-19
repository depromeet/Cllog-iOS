//
//  Dependency+Core.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 1/27/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Core {}
}

public extension TargetDependency.Core {
    static func ClLogUI(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "ClLogUI",
            path: .relativeToCore(path: "ClLogUI", service: service)
        )
    }
    
    static func core(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Core",
            path: .relativeToCore(path: "Core", service: service)
        )
    }
}
