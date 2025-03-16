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
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var userInfoState = UserInfoFeature.State()
        var storiesState = StoriesFeature.State()
        
        var storyId: Int
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action {
        case userInfoAction(UserInfoFeature.Action)
        case storiesAction(StoriesFeature.Action)
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case moreButtonTapped
        case fetchStorySuccess(Story)
        case fetchSummarySuccess(StorySummary)
        case fetchFailure(Error)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.userInfoState, action: \.userInfoAction) {
            UserInfoFeature()
        }
        
        Scope(state: \.storiesState, action: \.storiesAction) {
            StoriesFeature()
        }
        
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
            return .none
            
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
}
