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
    struct SPM {}
}

public extension TargetDependency.Framework {
    static let Starlink = TargetDependency.project(target: "Starlink", path: .releativeStarlink(.cllog))
}

public extension TargetDependency.Library {
    static let tca = TargetDependency.external(name: "ComposableArchitecture")
    static let alamofire = TargetDependency.external(name: "Alamofire")
    static let then = TargetDependency.external(name: "Then")
    static let swinject = TargetDependency.external(name: "Swinject")
    static let KakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser")
    
    // 네트워크
    static let pulse = TargetDependency.external(name: "Pulse")
    static let pulseUI = TargetDependency.external(name: "PulseUI")
    static let pulseProxy = TargetDependency.external(name: "PulseProxy")
    
    // 파이어베이스
    static let FirebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
//    static let FirebaseMessaging = TargetDependency.external(name: "FirebaseMessaging")
//    static let FirebasePerformance = TargetDependency.external(name: "FirebasePerformance")
//    static let FirebaseRemoteConfig = TargetDependency.external(name: "FirebaseRemoteConfig")
}
