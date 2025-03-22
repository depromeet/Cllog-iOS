//
//  CalendarDetailFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import StoryDomain

@Reducer
public struct CalendarDetailFeature {
    @Dependency(\.fetchStoryUseCase) var fetchStoryUseCase
    @Dependency(\.editMemoUseCase) var editMemoUseCase
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var userInfoState = UserInfoFeature.State()
        var storiesState = StoriesFeature.State()
        var isPresentMoreBottomSheet: Bool = false
        var moreBottomSheetItem: [MoreItem] = MoreItem.allCases
        var isMemoEditMode: Bool = false
        
        var storyId: Int
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case userInfoAction(UserInfoFeature.Action)
        case storiesAction(StoriesFeature.Action)
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case moreButtonTapped
        case moreItemTapped(MoreItem)
        case editCompleteTapped
        case switchingToMemoEditMode(Bool)
        case fetchStorySuccess(Story)
        case fetchSummarySuccess(StorySummary)
        case editMemoSuccess(String)
        case fetchFailure(Error)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.userInfoState, action: \.userInfoAction) {
            UserInfoFeature()
        }
        
        Scope(state: \.storiesState, action: \.storiesAction) {
            StoriesFeature()
        }
        
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension CalendarDetailFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .merge(
                fetchStory(storyId: state.storyId),
                fetchSummary(storyId: state.storyId)
            )
            
        case .backButtonTapped:
            return .none
            
        case .shareButtonTapped:
            return .none
            
        case .moreButtonTapped:
            state.isPresentMoreBottomSheet = true
            return .none
            
        case .moreItemTapped(let moreItem):
            switch moreItem {
            case .edit:
                state.isMemoEditMode = true
            case .delete:
                return .none
            }
            state.isPresentMoreBottomSheet = false
            return .send(.switchingToMemoEditMode(state.isMemoEditMode))
            
        case .editCompleteTapped:
            state.isMemoEditMode = false
            return .merge(
                .send(.switchingToMemoEditMode(state.isMemoEditMode)),
                executeEditMemo(storyId: state.storyId, text: state.userInfoState.editMemo)
            )
            
        case .switchingToMemoEditMode(let isEdit):
            return .send(.userInfoAction(.editMemo(state.isMemoEditMode)))
            
        case .editMemoSuccess(let text):
            return .send(.userInfoAction(.updateMemo(text)))
            
        case .fetchStorySuccess(let story):
            return .send(
                .storiesAction(
                    .updateStory(story)
                )
            )
            
        case .fetchSummarySuccess(let summary):
            return .send(
                .userInfoAction(
                    .updateStoryInfo(summary)
                )
            )
            
        case .fetchFailure(let error):
            print(error)
            return .none
        default:
            return .none
        }
    }
}

extension CalendarDetailFeature {
    func fetchStory(storyId: Int) -> Effect<Action> {
        .run { send in
            do {
                let story = try await fetchStoryUseCase.fetchStory(storyId)
                await send(.fetchStorySuccess(story))
            } catch {
                await send(.fetchFailure(error))
            }
        }
    }
    
    func fetchSummary(storyId: Int) -> Effect<Action> {
        .run { send in
            do {
                let summary = try await fetchStoryUseCase.fetchSummary(storyId)
                await send(.fetchSummarySuccess(summary))
            } catch {
                await send(.fetchFailure(error))
            }
        }
    }
    
    func executeEditMemo(storyId: Int, text: String) -> Effect<Action> {
        .run { send in
            do {
                try await editMemoUseCase.execute(storyId: storyId, memo: text)
                await send(.editMemoSuccess(text))
            } catch {
                await send(.fetchFailure(error))
            }
        }
    }
}
