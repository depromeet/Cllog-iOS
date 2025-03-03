//
//  AppData.swift
//  Data
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

enum AppData {
    enum Key: String {
        case token
    }
    
    @UserDefault(key: Key.token.rawValue, defaultValue: nil)
    static var token: AuthTokenDTO?
    
    static func clearLocalData() {
        UserDefaults.standard.removeObject(forKey: Key.token.rawValue)
    }
}
