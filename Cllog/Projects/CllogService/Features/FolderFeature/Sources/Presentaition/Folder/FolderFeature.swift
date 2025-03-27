//
//  FolderFeature.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import FolderDomain
import Shared

@Reducer
public struct FolderFeature {
    @Dependency(\.filteredAttemptsUseCase) private var filteredAttemptsUseCase
    @Dependency(\.fetchFilterableAttemptInfoUseCase) private var fetchFilterableAttemptInfoUseCase
    
    @ObservableState
    public struct State: Equatable {
        var filterableAttemptInfo: FilterableAttemptInfo?
        var attempts = [Attempt]()
        let chips = SelectedChip.allCases
        var attemptFilter = AttemptFilter()
        var viewState = ViewState.loading
        var showSelectGradeBottomSheet = false
        var showSelectCragBottomSheet = false
        var searchCragName = ""
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case completeChipTapped
        case failChipTapped
        case gradeChipTapped
        case cragChipTapped
        case getFilterableInfo(_ data: FilterableAttemptInfo)
        case didSelectCrag(_ crag: Crag)
        case didSelectGrade(_ grade: Grade)
        case getFilteredAttempts(_ attempt: [Attempt])
        case setViewState(_ state: ViewState)
        case moveToAttempt(_ attemptId: Int)
        case fail
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                return fetchInitialData()
                
            case .completeChipTapped:
                let filter = state.attemptFilter.toggleResult(.complete)
                state.attemptFilter = filter
                return fetchFilteredAttempts(filter)
                
            case .failChipTapped:
                let filter = state.attemptFilter.toggleResult(.fail)
                state.attemptFilter = filter
                return fetchFilteredAttempts(filter)
                
            case .gradeChipTapped:
                guard state.attemptFilter.grade == nil else {
                    let filter = state.attemptFilter.updateGrade(nil)
                    state.attemptFilter = filter
                    return fetchFilteredAttempts(filter)
                }
                state.showSelectGradeBottomSheet = true

                return .none
            case .cragChipTapped:
                guard state.attemptFilter.crag == nil else {
                    let filter = state.attemptFilter.updateCrag(nil)
                    state.attemptFilter = filter
                    return fetchFilteredAttempts(filter)
                }
                state.searchCragName = ""
                state.showSelectCragBottomSheet = true
                return .none
                
            case .getFilterableInfo(let info):
                state.filterableAttemptInfo = info
                return .none
                
            case .didSelectCrag(let crag):
                let filter = state.attemptFilter.updateCrag(crag)
                state.attemptFilter = filter
                state.showSelectCragBottomSheet = false
                return fetchFilteredAttempts(filter)
                
            case .didSelectGrade(let grade):
                let filter = state.attemptFilter.updateGrade(grade)
                state.attemptFilter = filter
                state.showSelectGradeBottomSheet = false
                return fetchFilteredAttempts(filter)
                
            case .setViewState(let viewState):
                state.viewState = viewState
                return .none
            case .getFilteredAttempts(let attempts):
                state.attempts = attempts
                return .none
            case .moveToAttempt:
                return .none
            case .fail:
                return .none
                
            }
        }
    }
    
    private func fetchInitialData() -> Effect<Action> {
        return .run { send in
            async let requestFilterableInfo = fetchFilterableAttemptInfoUseCase.execute()
            async let allAttempts = filteredAttemptsUseCase.execute(nil)
            
            do {
                let (filterableInfo, attemptsResult) = try await (requestFilterableInfo, allAttempts)
                await send(.getFilterableInfo(filterableInfo))
                await send(.getFilteredAttempts(attemptsResult))
                await send(.setViewState(attemptsResult.isEmpty ? .empty : .content))
            } catch {
                await send(.setViewState(.empty))
            }
        }
    }
    
    private func fetchFilteredAttempts(_ filter: AttemptFilter) -> Effect<Action> {
        return .run { send in
            do {
                let attempts = try await filteredAttemptsUseCase.execute(filter)
                await send(.getFilteredAttempts(attempts))
                await send(.setViewState(attempts.isEmpty ? .empty : .content))
            } catch {
                await send(.setViewState(.empty))
            }
        }
    }
}

extension FolderFeature {
    public enum ViewState: Equatable {
        case loading
        case empty
        case content
    }
    
    enum SelectedChip: Hashable, CaseIterable {
        case complete
        case fail
        case grade
        case crag
    }
}
