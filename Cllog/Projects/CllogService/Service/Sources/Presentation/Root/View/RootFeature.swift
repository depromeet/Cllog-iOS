//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Domain

import MainFeature
import VideoFeature

import ComposableArchitecture
import LoginFeature
import Shared

@Reducer
public struct RootFeature {
    public weak var coordinator: Coordinator?
    
    @ObservableState
    public struct State: Equatable {
        var autoLoginState: AutoLoginFeature.State?
        var loginState: LoginFeature.State?
        var mainState: MainFeature.State?
    }
    
    public enum Action {
        case onAppear
        
        // autoLogin
        case autoLoginAction(AutoLoginFeature.Action)
        
        // login
        case loginAction(LoginFeature.Action)
        
        // Main
        case mainAction(MainFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reducerCore)
            .ifLet(\.autoLoginState, action: \.autoLoginAction) {
                AutoLoginFeature()
            }
            .ifLet(\.loginState, action: \.loginAction) {
                LoginFeature()
            }
            .ifLet(\.mainState, action: \.mainAction) {
                var feature = MainFeature()
                feature.coordinator = self.coordinator
                
                return feature
            }
    }
    
    /// Home Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Home Action
    /// - Returns: Effect<HomeAction>
    private func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.autoLoginState = .init()
            return .none
            
        case .autoLoginAction(let action):
            return autoLoginCore(&state, action)
            
        case .loginAction(let action):
            return loginCore(&state, action)
            
        case .mainAction(let action):
            return mainCore(&state, action)
        }
    }
}

// MARK: - Login Action
private extension RootFeature {
    
    /// 자동 로그인 Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: AutoLogin Action
    /// - Returns: Effect
    func autoLoginCore(
        _ state: inout State,
        _ action: (AutoLoginFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.loginState = LoginFeature.State()
            state.autoLoginState = nil
            return .none
        }
    }
    
    /// Login Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Login Action
    /// - Returns: Effect
    func loginCore(
        _ state: inout State,
        _ action: (LoginFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .successLogin:
            // 로그인 성공
            state.mainState = .init()
            state.loginState = nil
            return .none
        default:
            return .none
        }
    }
    
    
    /// 자동 로그인
    /// - Returns: 자동 로그인 결과
    func checkLoginStatus() -> Bool {
        // TODO: 로그인 여부 확인
        return false
    }
}

private extension RootFeature {
    
    /// Main Tab Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Main Tab Action
    /// - Returns: Effect
    func mainCore(
        _ state: inout State,
        _ action: (MainFeature.Action)
    ) -> Effect<Action> {
        return .none
    }
}
