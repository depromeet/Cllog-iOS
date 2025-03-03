//
//  MainFeature.swift
//  MainFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct MainFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        var tabTitles: [String]
        var selectedImageNames: [String]
        var unselectedImageNames: [String]
        var showOverlay = false
        
        public init(
            tabTitles: [String],
            selectedImageNames: [String],
            unselectedImageNames: [String]
        ) {
            self.tabTitles = tabTitles
            self.selectedImageNames = selectedImageNames
            self.unselectedImageNames = unselectedImageNames
        }
    }
    
    public enum Action {
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
