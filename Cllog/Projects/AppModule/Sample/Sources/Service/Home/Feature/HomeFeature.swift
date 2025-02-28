//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    
    public struct State: Equatable {
        public var destination: Destination? = nil
    }
    
    public enum Action {
        case onAppear
        case setDestination(Destination)
    }
    
    public enum Destination {
        case login
        case main
    }
    
    private let logger: (String) -> Void
    
    public init(
        logger: @escaping @Sendable (String) -> Void
    ) {
        self.logger = logger
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            logger("\(Self.self) action :: \(action)")
            switch action {
            case .onAppear:
                // auto login fetch
                state.destination = .login
                return .none
                
            case .setDestination(let destination):
                state.destination = destination
                return .none
            }
        }
    }
}

