//
//  FolderFeature.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture
import FolderDomain

@Reducer
public struct FolderFeature {
    @Dependency(\.folderListUseCase) private var folderListUsecase
    
    @ObservableState
    public struct State {
        var grades = [Grade]()
        var crages = [Crag]()
        var attempts = [Attempt]()
        var selectedChip: Set<SelectedChip> = []
        var selectedCragName = ""
        var countOfFilteredStories = 30 // FIXME: 서버 연결
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
        case updateStoryInfo(grades: [Grade], crages: [Crag], attempts: [Attempt])
        case didSelectGrade(_ grade: Grade)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                return getStoryInfo()
            case .completeChipTapped:
                state.countOfFilteredStories = 20
                state.selectedChip.formSymmetricDifference([.complete])
                return .none
            case .failChipTapped:
                state.countOfFilteredStories = 10
                state.selectedChip.formSymmetricDifference([.fail])
                return .none
            case .gradeChipTapped:
                state.countOfFilteredStories = 5
                if state.selectedGrade != nil {
                    state.selectedGrade = nil
                } else {
                    state.showSelectGradeBottomSheet = true
                }
                return .none
            case .cragChipTapped(let cragName):
                state.showSelectCragBottomSheet = true
                state.countOfFilteredStories = 1
                state.selectedCragName = cragName
                state.selectedChip.formSymmetricDifference([.crag])
                return .none
            case .updateStoryInfo(let grades, let crages, let stories):
                state.grades = grades
                state.crages = crages
                state.attempts = stories
                return .none
            case .didSelectGrade(let grade):
                state.selectedGrade = grade
                state.showSelectGradeBottomSheet = false
                return .none
            }
        }
    }
    
    private func getStoryInfo() -> Effect<Action> {
        return .run { send in
            let crages = try? await folderListUsecase.getCrages()
            let grades = try? await folderListUsecase.getGrades()
            let attempts = try? await folderListUsecase.getFilteredAttempts()
            await send(.updateStoryInfo(grades: grades ?? [], crages: crages ?? [], attempts: attempts ?? []))
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
