//
//  AttemptFeature.swift
//  FolderFeature
//
//  Created by soi on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
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
        let editActions = AttemptEditAction.allCases
        var stampPositions = [CGFloat]()
        
        var showEditAttemptBottomSheet = false
        public init(attemptId: Int) {
            self.attemptId = attemptId
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case moreButtonTapped
        case moreActionTapped(_ action: AttemptEditAction)
        case videoTapped
        case stampTapped(id: Int)
        
        case onSplitPositionsCalculated(positions: [CGFloat])
        case getAttempt(attempt: ReadAttempt)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return fetchAttempt(state.attemptId)
            case .backButtonTapped:
                return .none
            case .shareButtonTapped:
                return .none
            case .moreButtonTapped:
                state.showEditAttemptBottomSheet = true
                return .none
            case .moreActionTapped(let action):
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

extension AttemptFeature {
    public enum AttemptEditAction: CaseIterable {
        case video
        case result
        case info
        case delete
        
        var title: String {
            switch self {
            case .video:    "영상/스탬프 편집"
            case .result:   "완등/실패 수정"
            case .info:     "암장 정보, 난이도 수정"
            case .delete:   "영상 기록 삭제"
            }
        }
        
        var leadingIcon: Image {
            switch self {
            case .video:    Image.clLogUI.cut
            case .result:   Image.clLogUI.tag
            case .info:     Image.clLogUI.location
            case .delete:   Image.clLogUI.delete
            }
        }
        
        var color: Color {
            switch self {
            case .video, .result, .info:
                Color.clLogUI.white
            case .delete:
                Color.clLogUI.fail
            }
        }
    }
}
