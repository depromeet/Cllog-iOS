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
public struct CalendarFeature {
    
    @ObservableState
    public struct State {
        public init() {}
    }
    
    public enum Action {
        
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
