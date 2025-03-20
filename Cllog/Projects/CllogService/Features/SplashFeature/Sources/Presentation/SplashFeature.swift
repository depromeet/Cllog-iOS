//
//  SplashFeature.swift
//  SplashFeature
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

public enum Destination {
    case login
    case main
}

@Reducer
public struct SplashFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var isAnimationFinished: Bool = false
        public init() {}
    }
    
    public enum Action: Equatable {
        case animationFinished
        case finish(Destination)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension SplashFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .animationFinished:
            state.isAnimationFinished = true
            return .send(.finish(.login))
        default:
            return .none
        }
    }
}
