//
//  Dependency+Domain.swift
//  Config
//
//  Created by Junyoung Lee on 1/21/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Domains {
        public struct Sample {}
        public struct Domain {}
    }
}

public extension TargetDependency.Domains {
    static func project(name: String, service: ServiceType) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToDomain(path: name, service: service)
        )
    }
}

public extension TargetDependency.Domains.Domain {
    static let name = "Domain"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)",
        service: .sample
    )
}

public extension TargetDependency.Domains.Sample {
    static let name = "Sample"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .sample
    )
}
