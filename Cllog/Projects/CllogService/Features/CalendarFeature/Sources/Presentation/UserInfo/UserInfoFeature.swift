//
//  UserInfoFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

import CalendarDomain

@Reducer
public struct UserInfoFeature {
    
    @ObservableState
    public struct State: Equatable {
        var isOpen: Bool = false
        var summary: CalendarSummary = CalendarSummary()
        var currentMonth: Int = 0
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case updateUserInfo(CalendarSummary)
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
            case let .updateUserInfo(summary):
                state.summary = summary
                return .none
            default:
                return .none
            }
        }
    }
}
