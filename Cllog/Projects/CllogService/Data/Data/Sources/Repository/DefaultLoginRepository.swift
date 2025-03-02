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
    private let dataSource: LoginDataSource
    
    public init(dataSource: LoginDataSource) {
        self.dataSource = dataSource
    }
    
    public func login(_ idToken: String) async throws {
        
        do {
            let response: AuthTokenResponseDTO = try await
            dataSource.kakaoLogin(idToken: idToken)
//            APIService.shared.request(LoginDataSource.kakaoLogin(idToken: idToken))
            
            // TODO: Access Token keychain 저장
            print("✅ access token", response.accessToken)
            print("✅ refresh token", response.refreshToken)
            
        } catch {
            throw error
        }
    }
    
    public func login(code: String, codeVerifier: String) async throws {
        do {
            let response: AuthTokenResponseDTO = try await
            dataSource.appleLogin(code: code, codeVerifier: codeVerifier)
//            APIService.shared.request(LoginDataSource.appleLogin(code: code, codeVerifier: codeVerifier))
            
            // TODO: Access Token keychain 저장
            print("✅ access token", response.accessToken)
            print("✅ refresh token", response.refreshToken)
            
        } catch {
            throw error
        }
    }
}
