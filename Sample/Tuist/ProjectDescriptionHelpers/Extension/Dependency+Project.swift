//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung Lee on 1/9/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Modules {}
    struct Core {}
    struct Umbrella {}
}

public extension TargetDependency.Modules {
    static func data(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Data",
            path: .releativeData(service)
        )
    }
    
    static func shared(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Shared",
            path: .relativeToModule(path: "Shared", service: service)
        )
    }
    
    static func networkModule(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "NetworkModule",
            path: .relativeToModule(path: "NetworkModule", service: service)
        )
    }
    
    static func thirdPartyLibrary(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "ThirdPartyLibrary",
            path: .relativeToModule(path: "ThirdPartyLibrary", service: service)
        )
    }
}

public extension TargetDependency.Core {
    static func designKit(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "DesignKit",
            path: .relativeToCore(path: "DesignKit", service: service)
        )
    }
    
    static func core(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Core",
            path: .relativeToCore(path: "Core", service: service)
        )
    }
}

public extension TargetDependency.Umbrella {
    static let umbrella = TargetDependency.project(
        target: "Umbrella",
        path: .relativeUmbrella()
    )
}
