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
        
        var storyId: Int
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action {
        case userInfoAction(UserInfoFeature.Action)
        case setStoryId(Int)
    }
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.userInfoState, action: \.userInfoAction) {
            UserInfoFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .setStoryId(let id):
                print("storyId: \(id)")
                state.storyId = id
                
                Task {
                    let story = try await fetchStoryUseCase.fetchStory(id)
                    let summary = try await fetchStoryUseCase.fetchSummary(id)
                    
                    print(story)
                    print(summary)
                }
                return .none
            default:
                return .none
            }
        }
    }
}
