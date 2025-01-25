//
//  Dependency+Library.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Library {}
}

public extension TargetDependency.Library {
    static let snapKit = TargetDependency.external(name: "SnapKit")
    static let alamofire = TargetDependency.external(name: "Alamofire")
    static let then = TargetDependency.external(name: "Then")
}
