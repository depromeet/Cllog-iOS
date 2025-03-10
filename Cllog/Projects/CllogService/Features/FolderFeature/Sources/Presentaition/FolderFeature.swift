//
//  FolderFeature.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import FolderDomain

@Reducer
public struct FolderFeature {
    @Dependency(\.folderListUseCase) private var folderListUsecase
    
    @ObservableState
    public struct State {
        var grades = [Grade]()
        var crages = [Crag]()
        var stories = [Attempt]()
        var selectedChip: Set<SelectedChip> = []
        var selectedCragName = ""
        var countOfFilteredStories = 30 // FIXME: 서버 연결
        var selectedGrade = ""
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case completeChipTapped
        case failChipTapped
        case gradeChipTapped
        case cragChipTapped(cragName: String)
        case updateStoryInfo(grades: [Grade], crages: [Crag], attempts: [Attempt])
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
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
                state.selectedGrade = "파랑"
                state.countOfFilteredStories = 5
                state.selectedChip.formSymmetricDifference([.grade])
                return .none
            case .cragChipTapped(let cragName):
                state.countOfFilteredStories = 1
                state.selectedCragName = cragName
                state.selectedChip.formSymmetricDifference([.crag])
                return .none
            case .updateStoryInfo(let grades, let crages, let stories):
                state.grades = grades
                state.crages = crages
                state.stories = stories
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
