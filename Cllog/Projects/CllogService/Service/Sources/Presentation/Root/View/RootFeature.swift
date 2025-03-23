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
import SplashFeature
import Shared

@Reducer
public struct RootFeature {
    
    @ObservableState
    public struct State: Equatable {
        var loginState: LoginFeature.State?
        var mainState: MainFeature.State?
        var splashState: SplashFeature.State? = .init()
    }
    
    public enum Action {
        case onAppear
        case changeDestination(Destination)
        
        // Splash
        case splashAction(SplashFeature.Action)
        
        // login
        case loginAction(LoginFeature.Action)
        
        // Main
        case mainAction(MainFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reducerCore)
            .ifLet(\.loginState, action: \.loginAction) {
                LoginFeature()
            }
            .ifLet(\.mainState, action: \.mainAction) {
                MainFeature()
            }
            .ifLet(\.splashState, action: \.splashAction) {
                SplashFeature()
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
            return .none
            
        case .splashAction(let action):
            return splashCore(&state, action)
            
        case .loginAction(let action):
            return loginCore(&state, action)
            
        case .mainAction(let action):
            return mainCore(&state, action)
        case .changeDestination(let destination):
            state.splashState = nil
            switch destination {
            case .login:
                state.mainState = nil
                state.loginState = LoginFeature.State()
            case .main:
                state.loginState = nil
                state.mainState = MainFeature.State()
            }
            return .none
        }
    }
}

// MARK: - Login Action
private extension RootFeature {
    
    /// 스플레시 Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Splash Action
    /// - Returns: Effect
    func splashCore(
        _ state: inout State,
        _ action: (SplashFeature.Action)
    ) -> Effect<Action> {
        switch action {
        case .finish(let destination):
            return .send(.changeDestination(destination))
        default:
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
            return .send(.changeDestination(.main))
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
