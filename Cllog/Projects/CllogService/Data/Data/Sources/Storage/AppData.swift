//
//  AppData.swift
//  Data
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

enum AppData {
    enum UserDefaultKey: String, CaseIterable {
        case didCompleteOnboarding
    }
    
    enum KeychainKey: String, CaseIterable {
        case token
    }
    
    @Keychain(key: KeychainKey.token.rawValue, itemClass: .generic)
    static var token: AuthTokenDTO?
    
    static func clearLocalData() {
        UserDefaultKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}
