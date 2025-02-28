//
//  Dependency+Feature.swift
//  Config
//
//  Created by Junyoung Lee on 1/21/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Features {
        public struct Capture {}
        public struct Login {}
        public struct Root {}
        public struct Main {}
    }
}

public extension TargetDependency.Features {
    static func project(name: String, service: ServiceType) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToFeature(path: name, service: service)
        )
    }
}

public extension TargetDependency.Features.Root {
    static let name = "Root"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .cllog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .cllog)
    )
}

public extension TargetDependency.Features.Main {
    static let name = "Main"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .cllog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .cllog)
    )
}

public extension TargetDependency.Features.Login {
    static let name = "Login"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .cllog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .cllog)
    )
}

public extension TargetDependency.Features.Capture {
    static let name = "Capture"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .cllog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .cllog)
    )
}
