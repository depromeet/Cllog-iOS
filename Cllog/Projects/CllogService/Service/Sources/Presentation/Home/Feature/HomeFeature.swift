//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import LoginFeature

@Reducer
public struct HomeFeature {
    
    public struct State: Equatable {
        var destination: Destination = .splash
        var login = LoginFeature.State()

        
    }
    
    enum Destination: Equatable {
        case splash
        case login
        case main
    }
    
    public enum Action {
        case onAppear
        case loginAction(LoginFeature.Action)
        case loginCompleted
    }
    
    private let logger: (String) -> Void
    
    public init(
        logger: @escaping @Sendable (String) -> Void
    ) {
        self.logger = logger
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.login, action: \.loginAction) {
            LoginFeature()
        }
        
        Reduce { state, action in
            logger("\(Self.self) action :: \(action)")
            switch action {
            case .onAppear:
                state.destination = checkLoginStatus() ? .main : .login
                return .none
                
            case .loginAction(.successLogin):
                state.destination = .main
                return .none
                
            case .loginAction:
                return .none
                
            case .loginCompleted:
                return .none
            }
        }
    }

    
    func checkLoginStatus() -> Bool {
        // TODO: 로그인 여부 확인
        return false
    }
}

