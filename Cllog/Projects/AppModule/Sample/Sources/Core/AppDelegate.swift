//
//  SampleApp.swift
//  SampleApp
//
//  Created by Junyoung on 1/8/25.
//

import UIKit

import Firebase
import DesignKit
import KakaoSDKCommon
import Photos
 
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        
        if let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KakaoNativeAppKey") as? String {
            KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        }
        
        Task {
            await requestPhotoLibraryPermission()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

extension AppDelegate {
    private func requestPhotoLibraryPermission() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            print("✅ 사진첩 권한 허용됨")
        case .restricted, .denied, .notDetermined:
            print("❌ 권한 없음 또는 취소됨")
        @unknown default:
            break
        }
    }
}
