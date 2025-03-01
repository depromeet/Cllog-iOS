//
//  LoginFeature.swift
//  LoginFeature
//
//  Created by soi on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import LoginDomain
import KakaoSDKUser

@Reducer
public struct LoginFeature {
    private let useCase: LoginUseCase
    
    public init(useCase: LoginUseCase) {
        self.useCase = useCase
    }
    
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
        case failLogin
    }
    
    public var body: some ReducerOf<Self> {
        // TODO: acceess token 키체인 저장 후 화면 이동 필요
        Reduce { state, action in
            switch action {
            case .kakaoLoginButtonTapped:
                return .run { send in
                    do {
                        guard let idToken = try await executeKakaoLogin() else {
                            return await send(.failLogin)
                        }
                        try await useCase.execute(idToken: idToken)
                        await send(.successLogin)
                    } catch {
                        await send(.failLogin)
                    }
                }
                
            case .appleLoginButtonTapped:
                return .none
                
            case .successLogin:
                // 로그인 성공
                return .none
            case .failLogin:
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
                if let error {
                    continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: oauthToken?.idToken)
            }
        }
    }
    
    @MainActor
    private func loginWithKakaoAccount() async throws -> String? {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error {
                    continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: oauthToken?.idToken)
            }
        }
    }
}
