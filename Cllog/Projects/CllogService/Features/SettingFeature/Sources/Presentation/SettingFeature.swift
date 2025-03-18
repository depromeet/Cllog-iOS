//
//  SettingFeature.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct SettingFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {
        case backButtonTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension SettingFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}
