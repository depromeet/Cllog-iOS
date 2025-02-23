//
//  Dependency+Library.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Framework {}
    struct Library {}
}

public extension TargetDependency.Framework {
    static let Starlink = TargetDependency.project(target: "Starlink", path: "../../../../Projects/AppModule/Starlink")
}

public extension TargetDependency.Library {
    static let snapKit = TargetDependency.external(name: "SnapKit")
    static let alamofire = TargetDependency.external(name: "Alamofire")
    static let then = TargetDependency.external(name: "Then")
    
    // 네트워크
    static let pulse = TargetDependency.external(name: "Pulse")
    static let pulseUI = TargetDependency.external(name: "PulseUI")
    static let pulseProxy = TargetDependency.external(name: "PulseProxy")
}
