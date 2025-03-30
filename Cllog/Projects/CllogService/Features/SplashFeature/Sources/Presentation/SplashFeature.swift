//
//  SplashFeature.swift
//  SplashFeature
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import AccountDomain

public enum Destination {
    case login
    case main
    case onBoarding
    case nickName
}

@Reducer
public struct SplashFeature {
    @Dependency(\.validateUserSessionUseCase) private var validateUserSessionUseCase
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var isAnimationFinished: Bool = false
        var isValidUserFinished: Bool = false
        
        var isValidUserSession: Bool = false
        public init() {}
    }
    
    public enum Action: Equatable {
        case onAppear
        case animationFinished
        case validateUserSession(Bool)
        case checkCompletion
        case finish(Destination)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension SplashFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return validateUserSession()
        case .validateUserSession(let result):
            state.isValidUserSession = result
            state.isValidUserFinished = true
            return .send(.checkCompletion)
        case .animationFinished:
            state.isAnimationFinished = true
            return .send(.checkCompletion)
        case .checkCompletion:
            guard state.isAnimationFinished && state.isValidUserFinished else { return .none }
            
            if !SplashDataManager.hasCompleted {
                SplashDataManager.hasCompleted = true
                return .send(.finish(.onBoarding))
            }
            
            if state.isValidUserSession {
                return .send(.finish(.main))
            } else {
                return .send(.finish(.login))
            }
        default:
            return .none
        }
    }
    
    private func validateUserSession() -> Effect<Action> {
        .run { send in
            let result = validateUserSessionUseCase.fetch()
            await send(.validateUserSession(result))
        }
    }
}
