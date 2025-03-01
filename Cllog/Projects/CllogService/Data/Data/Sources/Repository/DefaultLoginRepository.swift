//
//  DefaultLoginRepository.swift
//  Data
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import LoginDomain

public struct DefaultLoginRepository: LoginRepository {
    public init() {}
    
    public func login(token: String, idToken: String?) async throws {
        
        // TODO: Server 연결
        
    }
}
