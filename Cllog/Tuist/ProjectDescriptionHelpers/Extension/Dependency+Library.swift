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
    static let SpaceX = TargetDependency.project(target: "SpaceX", path: "../../../../Projects/AppModule/SpaceX")
}

public extension TargetDependency.Library {
    static let alamofire = TargetDependency.external(name: "Alamofire")
    static let then = TargetDependency.external(name: "Then")
    static let tca = TargetDependency.external(name: "ComposableArchitecture")
}
