//
//  LoginFeature.swift
//  LoginFeature
//
//  Created by soi on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import KakaoSDKUser
import Foundation

@Reducer
public struct LoginFeature {
    // TODO: UseCase
    
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        var isLoggingIn: Bool = false
        var errorMessage: String?
    }
    
    public enum Action {
        case kakaoLoginButtonTapped
        case appleLoginButtonTapped
        case successLogin
    }
    
    public var body: some ReducerOf<Self> {
        // TODO: acceess token 키체인 저장 후 화면 이동 필요
        Reduce { state, action in
            switch action {
            case .kakaoLoginButtonTapped:
                return .run { send in
                    let _ = try await executeKakaoLogin()
                    await send(.successLogin)
                }
                
            case .appleLoginButtonTapped:
                return .none
                
            case .successLogin:
                // 로그인 성공
                return .none
            }
        }
    }
    
    @MainActor
    private func executeKakaoLogin() async throws -> String? {
        if UserApi.isKakaoTalkLoginAvailable() {
            return try await loginWithKakaoTalk()
        } else {
            return try await loginWithKakaoAccount()
        }
    }
    
    @MainActor
    private func loginWithKakaoTalk() async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    print("🚨", error.localizedDescription)
                    continuation.resume(throwing: error)
                } else if let token = oauthToken {
                    print("✅ accessToken:", token.accessToken)
                    print("✅ id token:", token.idToken)
                    continuation.resume(returning: token.idToken)
                }
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoAccount() async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    print("🚨", error.localizedDescription)
                    continuation.resume(throwing: error)
                } else if let token = oauthToken {
                    print("✅", token.accessToken)
                    print("✅", token.idToken)
                    continuation.resume(returning: token.idToken)
                }
            }
        }
    }
}
