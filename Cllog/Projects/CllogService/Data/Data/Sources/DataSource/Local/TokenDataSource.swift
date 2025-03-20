//
//  TokenDataSource.swift
//  Data
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker

public protocol TokenDataSource {
    func saveToken(_ token: AuthTokenDTO)
    func loadToken() -> TokenDTO?
    func clearToken()
}

public struct DefaultTokenDataSource: TokenDataSource {
    public init () {}
    
    public func saveToken(_ token: AuthTokenDTO) {
        AppData.token = token
    }
    
    public func loadToken() -> TokenDTO? {
        let token = AppData.token?.toToken()
        return token
    }
    
    public func clearToken() {
        AppData.clearLocalData()
    }
}
