//
//  CalendarDetailFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct CalendarDetailFeature {
    public init() {}
    
    @ObservableState
    public struct State {
        var userInfoState = UserInfoFeature.State()
        public init() {}
    }
    
    public enum Action {
        case userInfoAction(UserInfoFeature.Action)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.userInfoState, action: \.userInfoAction) {
            UserInfoFeature()
        }
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

func a() {
    Task {
        await MainActor.run {
            
        }
    }
}
