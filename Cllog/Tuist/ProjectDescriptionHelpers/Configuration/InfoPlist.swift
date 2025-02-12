//
//  InfoPlist.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import ProjectDescription

public struct InfoPlist {
    private static let commonInfoPlist: [String: Plist.Value] = [
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "LSSupportsOpeningDocumentsInPlace": true,
        "ITSAppUsesNonExemptEncryption": false,
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ]
    ]
    
    static func appInfoPlist(_ appConfiguration: AppConfiguration) -> [String: Plist.Value] {
        var infoPlist = commonInfoPlist
        infoPlist["CFBundleShortVersionString"] = .string(appConfiguration.shortVersion)
        infoPlist["CFBundleIdentifier"] = .string(appConfiguration.bundleIdentifier)
        infoPlist["CFBundleDisplayName"] = .string(appConfiguration.displayName)
        return infoPlist
    }
}
