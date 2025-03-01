//
//  CaptureFeature.swift
//  CaptureFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct CaptureFeature {
    
    private let logger: (String) -> Void
    
    public struct State: Equatable {
        public init() {}
        public var destination: Destination? = nil
    }
    
    public enum Action {
        case onAppear
    }
    
    public enum Destination {
        case main
    }
    
    public init (
        logger: @escaping @Sendable (String) -> Void
    ) {
        self.logger = logger
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            logger("\(Self.self) action :: \(action)")
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
