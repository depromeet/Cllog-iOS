//
//  MainFeature.swift
//  MainFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct MainFeature {
    
    public init(
        
    ) {
        
    }
    
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action {
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
