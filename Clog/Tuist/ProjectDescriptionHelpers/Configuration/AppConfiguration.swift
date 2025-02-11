//
//  AppConfiguration.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import Foundation
import ProjectDescription

public struct AppConfiguration {
    
    public init() {}
    
    let workspaceName = "Clog"
    let projectName: String = "Clog"
    let organizationName = "Supershy"
    let shortVersion: String = "1.0.0"
    let bundleIdentifier: String = "com.supershy.climbinglog.product"
    let displayName: String = "클로그"
    let destination: Set<Destination> = [.iPhone, .iPad]
    var entitlements: Entitlements? = nil
    let deploymentTarget: DeploymentTargets = .iOS("17.0")
    
    public var configurationName: ConfigurationName {
        return "Clog"
    }
    
    var infoPlist: [String : Plist.Value] {
        InfoPlist.appInfoPlist(self)
    }
    
    public var autoCodeSigning: SettingsDictionary {
        return SettingsDictionary().automaticCodeSigning(devTeam: "SUMATJC294")
    }
    
    var setting: Settings {
        return Settings.settings(
            base: autoCodeSigning,
            configurations: XCConfig.project
        )
    }
    
    let commonSettings = Settings.settings(
        base: SettingsDictionary.debugSettings
            .configureAutoCodeSigning()
            .configureVersioning()
            .configureTestability(),
        configurations: XCConfig.framework
    )
}
