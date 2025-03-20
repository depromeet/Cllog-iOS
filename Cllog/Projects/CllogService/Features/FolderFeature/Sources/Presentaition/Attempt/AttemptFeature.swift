//
//  AttemptFeature.swift
//  FolderFeature
//
//  Created by soi on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

import ComposableArchitecture

@Reducer
public struct AttemptFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        let attemptId: Int
        public init(attemptId: Int) {
            self.attemptId = attemptId
        }
    }
    
    public enum Action {
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case moreButtonTapped
        case videoTapped
        case stampTapped(id: String)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .backButtonTapped:
                return .none
            case .shareButtonTapped:
                return .none
            case .moreButtonTapped:
                return .none
            case .videoTapped:
                return .none
            case .stampTapped(id: let id):
                return .none
            }
        }
    }
}
