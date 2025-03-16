//
//  StoriesFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct StoriesFeature {
    @ObservableState
    public struct State: Equatable {
        
    }
    
    public enum Action: Equatable {
        
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce(reducerCore)
    }
}

extension StoriesFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        
    }
}
