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
        
        let attemptId: String
        public init(attemptId: String) {
            self.attemptId = attemptId
        }
    }
    
    public enum Action {
        
        case onAppear
        case didTapBackButton
        case didTapShareButton
        case didTapMoreButton
        case didTapVideoView
        case didTapStampView(id: String)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .didTapBackButton:
                return .none
            case .didTapShareButton:
                return .none
            case .didTapMoreButton:
                return .none
            case .didTapVideoView:
                return .none
            case .didTapStampView(id: let id):
                return .none
            }
        }
    }
}
