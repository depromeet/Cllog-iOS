//
//  DefaultLoginRepository.swift
//  Data
//
//  Created by soi on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import LoginDomain

public struct DefaultLoginRepository: LoginRepository {
    
    public init() {}
    
    public func login(_ idToken: String) async throws {
        
        do {
            let response: AuthTokenResponseDTO = try await
            APIService.shared.request(LoginAPI.kakaoLogin(idToken: idToken))
            
            // TODO: Access Token keychain 저장
            print("✅ access token", response.accessToken)
            print("✅ refresh token", response.refreshToken)
            
        } catch {
            throw error
        }
    }
}
