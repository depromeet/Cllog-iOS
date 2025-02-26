//
//  LoginFeature.swift
//  LoginFeature
//
//  Created by soi on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

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
    }
    
    public var body: some ReducerOf<Self> {
        // TODO: acceess token 키체인 저장 후 화면 이동 필요
        Reduce { state, action in
            switch action {
            case .kakaoLoginButtonTapped:
                return .none
                
            case .appleLoginButtonTapped:
                return .none
            }
        }
    }
}
