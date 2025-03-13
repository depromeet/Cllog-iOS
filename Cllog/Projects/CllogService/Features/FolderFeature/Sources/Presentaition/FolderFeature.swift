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
    @Dependency(\.attemptUseCase) private var attemptUseCase
    @Dependency(\.gradeUseCase) private var gradeUseCase
    @Dependency(\.cragUseCase) private var cragUseCase
    
    @ObservableState
    public struct State {
        var grades = [Grade]()
        var crags = [Crag]()
        var attempts = [Attempt]()
        var selectedChip: Set<SelectedChip> = []
        var selectedCragName = ""
        var selectedGrade: Grade?
        
        var showSelectGradeBottomSheet = false
        var showSelectCragBottomSheet = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case onAppear
        case completeChipTapped
        case failChipTapped
        case gradeChipTapped
        case cragChipTapped(cragName: String)
        case getFilterableDatas(grades: [Grade], crags: [Crag])
        case didSelectGrade(_ grade: Grade)
        case getFilteredAttempts(_ attempt: [Attempt])
        case getFilterableInfo
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
                state.selectedChip.formSymmetricDifference([.complete])
                return .none
            case .failChipTapped:
                state.selectedChip.formSymmetricDifference([.fail])
                return .none
            case .gradeChipTapped:
                if state.selectedGrade != nil {
                    state.selectedGrade = nil
                } else {
                    state.showSelectGradeBottomSheet = true
                }
                return .none
            case .cragChipTapped(let cragName):
                state.showSelectCragBottomSheet = true
                state.selectedCragName = cragName
                state.selectedChip.formSymmetricDifference([.crag])
                return .none
            case .getFilterableDatas(let grades, let crags):
                state.grades = grades
                state.crags = crags
                return .none
            case .didSelectGrade(let grade):
                state.selectedGrade = grade
                state.showSelectGradeBottomSheet = false
                return .none
            case .getFilteredAttempts(let attempts):
                state.attempts = attempts
                return .none
            case .getFilterableInfo:
                return .none
            case .fail:
                return .none
            }
        }
    }
    
    private func fetchInitialData() -> Effect<Action> {
        return .run { send in
            async let grades = gradeUseCase.getGrades()
            async let crags = cragUseCase.getCrags()
            async let allAttempts = attemptUseCase.getAttempts()
            
            do {
                let (gradesResult, cragsResults, attemptsResult) = try await (grades, crags, allAttempts)
                
                await send(.getFilterableDatas(grades: gradesResult, crags: cragsResults))
                await send(.getFilteredAttempts(attemptsResult))
            }
        }
    }
    
    private func getAttempts() -> Effect<Action> {
        return .run { send in
            do {
                let attempts = try await attemptUseCase.getFilteredAttempts()
                await send(.getFilteredAttempts(attempts))
                
            }
        }
    }
}

extension FolderFeature {
    enum SelectedChip: Hashable, CaseIterable {
        case complete
        case fail
        case grade
        case crag
    }
}
