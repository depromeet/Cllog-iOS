//
//  XCConfig.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import ProjectDescription

public struct XCConfig {
    private struct Path {
        static var framework: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Framework.xcconfig") }
        
        static var tests: ProjectDescription.Path { .relativeToRoot("xcconfigs/targets/iOS-Tests.xcconfig") }
        
        static func project(_ config: String) -> ProjectDescription.Path { .relativeToRoot("xcconfigs/Base/Projects/Project-\(config).xcconfig") }
    }
    
    public static let framework: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.framework),
        .debug(name: "Test", xcconfig: Path.framework),
        .release(name: "Production", xcconfig: Path.framework),
    ]
    
    public static let tests: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.tests),
        .debug(name: "Test", xcconfig: Path.tests),
        .release(name: "Production", xcconfig: Path.tests),
    ]
    
    public static let project: [Configuration] = [
        .debug(name: "Develop", xcconfig: Path.project("Develop")),
        .debug(name: "Test", xcconfig: Path.project("Test")),
        .release(name: "Production", xcconfig: Path.project("Production")),
    ]
}
