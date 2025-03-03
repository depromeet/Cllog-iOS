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
        "UILaunchScreen": [
            "BackgroundColor": "systemBackgroundColor"
        ],
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
        ],
        "LSApplicationQueriesSchemes" : [
            "kakaokompassauth",
        ],
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": [
                    "kakao$(KAKAO_NATIVE_APP_KEY)",
                ]
            ]
        ],
        "NSCameraUsageDescription": "이 앱은 프로필 사진 촬영을 위해 카메라 접근 권한이 필요합니다.",
    ]
    
    static func appInfoPlist(_ appConfiguration: AppConfiguration) -> [String: Plist.Value] {
        var infoPlist = commonInfoPlist
        infoPlist["CFBundleShortVersionString"] = .string(appConfiguration.shortVersion)
        infoPlist["CFBundleIdentifier"] = .string(appConfiguration.bundleIdentifier)
        infoPlist["CFBundleDisplayName"] = .string(appConfiguration.displayName)
        infoPlist["KakaoNativeAppKey"] = .string(appConfiguration.kakaoNativeAppKey)
        return infoPlist
    }
}
