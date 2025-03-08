//
//  CalendarFeature.swift
//  CalendarFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct CalendarMainFeature {
    
    @ObservableState
    public struct State {
        var userInfoState = UserInfoFeature.State()
        var calendarState = CalendarFeature.State()
        public init() {}
    }
    
    public enum Action {
        case userInfoAction(UserInfoFeature.Action)
        case calendarAction(CalendarFeature.Action)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        
        Scope(state: \.userInfoState, action: \.userInfoAction) {
            UserInfoFeature()
        }
        
        Scope(state: \.calendarState, action: \.calendarAction) {
            CalendarFeature()
        }
        
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
