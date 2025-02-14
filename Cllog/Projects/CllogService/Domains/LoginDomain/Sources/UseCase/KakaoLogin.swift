//
//  KakaoLogin.swift
//  LoginDomain
//
//  Created by soi on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct KakaoLogin: LoginUseCase {
    private let repository: LoginRepository
    
    public init(repository: LoginRepository) {
        self.repository = repository
    }
    
    public func login() async throws {
        try await repository.excute()
    }
}
