//
//  UserInfoFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct UserInfoFeature {
    
    @ObservableState
    public struct State: Equatable {
        var isOpen: Bool = false
        var numOfClimbDays: Int = 0
        var totalDurationMs: Int = 0
        var currentMonth: Int = 0
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case updateUserInfo(Int, Int, Int)
        case dropdownTapped
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .dropdownTapped:
                state.isOpen.toggle()
                return .none
            case let .updateUserInfo(numOfClimbDays, totalDurationMs, currentMonth):
                state.numOfClimbDays = numOfClimbDays
                state.totalDurationMs = totalDurationMs
                state.currentMonth = currentMonth
                return .none
            default:
                return .none
            }
        }
    }
}
