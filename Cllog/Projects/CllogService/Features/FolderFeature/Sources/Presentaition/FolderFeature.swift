//
//  FolderFeature.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

@Reducer
public struct FolderFeature {
    
    @ObservableState
    public struct State {
        var selectedChip: Set<SelectedChip> = []
        var selectedCragName = ""
        public init() {}
    }
    
    public enum Action {
        case completeChipTapped
        case failChipTapped
        case gradeChipTapped
        case cragChipTapped(cragName: String)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .completeChipTapped:
                state.selectedChip.formSymmetricDifference([.complete])
                return .none
            case .failChipTapped:
                state.selectedChip.formSymmetricDifference([.fail])
                return .none
            case .gradeChipTapped:
                state.selectedChip.formSymmetricDifference([.grade])
                return .none
            case .cragChipTapped(let cragName):
                state.selectedCragName = cragName
                state.selectedChip.formSymmetricDifference([.crag])
                return .none
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
