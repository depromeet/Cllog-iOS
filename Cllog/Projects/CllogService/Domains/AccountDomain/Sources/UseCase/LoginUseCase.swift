//
//  LoginUseCase.swift
//  AccountDomain
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol LoginUseCase {
    func execute(idToken: String) async throws
    func execute(code: String, codeVerifier: String) async throws
}

public struct DefaultLoginUseCase: LoginUseCase {
    public init(loginRepository: LoginRepository) {
        self.loginRepository = loginRepository
    }
    
    private let loginRepository: LoginRepository
    
    public func execute(idToken: String) async throws {
        try await loginRepository.login(idToken)
    }
    
    public func execute(code: String, codeVerifier: String) async throws {
        try await loginRepository.login(code: code, codeVerifier: codeVerifier)
    }
}
