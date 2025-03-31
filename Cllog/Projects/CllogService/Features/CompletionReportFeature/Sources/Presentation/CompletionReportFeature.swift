//
//  CompletionReportFeature.swift
//  CompletionReportFeature
//
//  Created by Junyoung on 3/31/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import StoryDomain

@Reducer
public struct CompletionReportFeature {
    @Dependency(\.fetchStoryUseCase) private var fetchStoryUseCase
    
    @ObservableState
    public struct State: Equatable {
        let storyId: Int
        var summary: StorySummary = StorySummary.init()
        
        public init(storyId: Int) {
            self.storyId = storyId
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case finish
        
        case fetchSummarySuccess(StorySummary)
        case errorHandler(Error)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
    
    public init() {}
}

extension CompletionReportFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return fetchSummary(state.storyId)
            
        case .fetchSummarySuccess(let summary):
            state.summary = summary
            return .none
            
        default:
            return .none
        }
    }
    
    private func fetchSummary(_ storyId: Int) -> Effect<Action> {
        .run { send in
            let summary = try await fetchStoryUseCase.fetchSummary(storyId)
            await send(.fetchSummarySuccess(summary))
        }
    }
}
