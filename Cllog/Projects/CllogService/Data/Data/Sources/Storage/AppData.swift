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
        
        var itemClass: KeychainItemType {
            switch self {
            case .token: .genericPassword
            }
        }
    }
    
    @Keychain(key: KeychainKey.token.rawValue, itemClass: KeychainKey.token.itemClass)
    static var token: AuthTokenDTO?
    
    static func clearLocalData() {
        UserDefaultKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
        
        KeychainKey.allCases.forEach {
            try? KeychainManager.shared.deleteItem(ofClass: $0.itemClass, key: $0.rawValue)
        }
    }
}
