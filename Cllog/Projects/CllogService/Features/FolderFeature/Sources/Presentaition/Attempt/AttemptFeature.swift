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
        @Presents var alert: AlertState<Action.Dialog>?
        
        let attemptId: Int
        var attempt: ReadAttempt?
        let editActions = AttemptEditAction.allCases
        
        var selectedAction: AttemptEditAction?
        var stampPositions = [CGFloat]()
        
        var showEditAttemptBottomSheet = false
        var showGradeBottomSheet = false
        var showEditGradeSheet = false
        var test = false
        var currentNavigationPath: AttemptNavigationPath? = nil

        public init(attemptId: Int) {
            self.attemptId = attemptId
        }
        
        var dynamicSheetHeight: CGFloat {
            switch selectedAction {
            case .video:
                251
            case .result:
                250
            case .info:
                700
            case .delete:
                300
            case nil: 300
            }
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case alert(PresentationAction<Dialog>)
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case moreButtonTapped
        case moreActionTapped(_ action: AttemptEditAction)
        case navigateToPath(_ path: AttemptNavigationPath?)
        case videoTapped
        case stampTapped(id: Int)
        
        case onSplitPositionsCalculated(positions: [CGFloat])
        case getAttempt(attempt: ReadAttempt)
        case deletedAttempt
        
        // edit actions
        case deleteActionTapped
        
        @CasePathable
        public enum Dialog: Equatable {
            case cancel
            case delete
        }
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
                return handleEditAction(action: action, id: state.attemptId)
            case .navigateToPath(let path):
                state.currentNavigationPath = path
                return .none
                
            case .videoTapped:
                return .none
            case .stampTapped(let id):
                // TODO: Seek to video
                return .none
                
            case .onSplitPositionsCalculated(let positions):
                state.stampPositions = positions
                return .none
            case .getAttempt(let attempt):
                state.attempt = attempt
                return .none
            case .deletedAttempt:
                return .none
            case .deleteActionTapped:
                state.showEditAttemptBottomSheet = false
                state.alert = AlertState {
                    TextState("영상 기록 삭제")
                } actions: {
                    ButtonState(action: .delete) {
                        TextState("삭제")
                    }
                    ButtonState(action: .cancel) {
                        TextState("취소")
                    }
                } message: {
                    TextState("기록을 삭제하면 복구가 어려워요.\n영상 기록을 삭제하시나요?")
                }
                return .none
            case .alert(.presented(.cancel)):
                
                return .none
            case .alert(.presented(.delete)):
                return deleteAttempt(state.attemptId)
                
            default: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AttemptFeature {
    private func handleEditAction(action: AttemptEditAction, id: Int) -> Effect<Action> {
        return .run { send in
            switch action {
            case .video:
                return await send(.navigateToPath(.editDetail(action)))
            case .result:
                return await send(.navigateToPath(.editDetail(action)))
            case .info:
                return await send(.navigateToPath(.editDetail(action)))
            case .delete:
                return await send(.deleteActionTapped)
            }
        }
    }
    
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
    
    private func deleteAttempt(_ attemptId: Int) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.delete(attemptId: attemptId)
                await send(.backButtonTapped)
            } catch  {
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
    
    
    public enum AttemptNavigationPath: Equatable, Hashable {
        case editDetail(AttemptEditAction)
        
        public func hash(into hasher: inout Hasher) {
            switch self {
            case .editDetail(let action):
                hasher.combine(0)
                hasher.combine(action)
            }
        }
        
        public static func == (lhs: AttemptNavigationPath, rhs: AttemptNavigationPath) -> Bool {
            switch (lhs, rhs) {
            case (.editDetail(let lhsAction), .editDetail(let rhsAction)):
                return lhsAction == rhsAction
            }
        }
    }
}
