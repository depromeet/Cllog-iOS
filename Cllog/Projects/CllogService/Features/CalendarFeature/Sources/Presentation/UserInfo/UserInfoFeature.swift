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
    public struct State {
        var isOpen: Bool = false
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
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
            default:
                return .none
            }
        }
    }
}
