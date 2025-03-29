//
//  DefaultTokenRepository.swift
//  Data
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AccountDomain
import Networker

public struct DefaultTokenRepository: TokenRepository {
    public init() {}
    public func fetchLoginType() -> LoginType {
        guard let provider = DefaultTokenDataSource().loadToken()?.provider else {
            return .apple
        }
        return LoginType.init(provider)
    }
    
    public func fetchValidateUserSession() -> Bool {
        return DefaultTokenDataSource().loadToken()?.refreshToken != nil
    }

    public func clearToken() async {
        DefaultTokenDataSource().clearToken()
    }
}
