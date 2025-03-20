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
    @Dependency(\.attemptUseCase) private var attemptUseCase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        let attemptId: Int
        var attempt: ReadAttempt?
        var stampPositions = [CGFloat]()
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
        case stampTapped(id: Int)
        
        case onSplitPositionsCalculated(positions: [CGFloat])
        case getAttempt(attempt: ReadAttempt)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return fetchAttempt(state.attemptId)
            case .backButtonTapped:
                return .none
            case .shareButtonTapped:
                return .none
            case .moreButtonTapped:
                return .none
            case .videoTapped:
                return .none
            case .stampTapped(let id):
                return .none
                
            case .onSplitPositionsCalculated(let positions):
                state.stampPositions = positions
                return .none
            case .getAttempt(let attempt):
                state.attempt = attempt
                return .none
            }
        }
    }
}

extension AttemptFeature {
    private func fetchAttempt(_ attemptId: Int) -> Effect<Action> {
        return .run { send in
            do {
                let attempt = try await attemptUseCase.execute(attemptId: attemptId)
                await send(.getAttempt(attempt: attempt))
            } catch {
                // TODO: show error message
                debugPrint(error.localizedDescription)
            }
        }
    }
}
