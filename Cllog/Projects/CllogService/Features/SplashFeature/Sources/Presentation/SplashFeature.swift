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
    @Dependency(\.loginUseCase) private var loginUseCase
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var isAnimationFinished: Bool = false
        var isValidUserFinished: Bool = false

        var refreshToken: String?
        public init() {}
    }
    
    public enum Action: Equatable {
        case onAppear
        case animationFinished
        case validateUserSession(refershToken: String?)
        case checkCompletion
        case refershToken(refrshToken: String)
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
        case .validateUserSession(let refershToken):
            state.refreshToken = refershToken
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
            
            if let refreshToken = state.refreshToken {
                return .send(.refershToken(refrshToken: refreshToken))
            } else {
                return .send(.finish(.login))
            }

        case .refershToken(let refreshToken):
            return .run { send in
                do {
                    try await loginUseCase.execute(refreshToken: refreshToken)
                    await send(.finish(.main))
                } catch {
                    await send(.finish(.login))
                }
            }

        default:
            return .none
        }
    }
    
    private func validateUserSession() -> Effect<Action> {
        .run { send in
            let refershToken = validateUserSessionUseCase.getRefreshToken()
            await send(.validateUserSession(refershToken: refershToken))
        }
    }
}
