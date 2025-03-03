//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Domain

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    
    private let logConsoleUseCase: LogConsoleUseCase
    
    @ObservableState
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
    
    public init(
        logConsoleUseCase: any LogConsoleUseCase
    ) {
        self.logConsoleUseCase = logConsoleUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            logConsoleUseCase.executeInfo(label: "\(Self.self)", message: "action :: \(action)")
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

