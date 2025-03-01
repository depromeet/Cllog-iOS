//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import ComposableArchitecture

import MainFeature
import CaptureFeature

@Reducer
public struct HomeFeature {
    
    public struct State: Equatable {
        public var destination: Destination? = nil
        
        // mainStore
        public var tabMainStore = MainFeature.State(
            tabTitles: [],
            selectedImageNames: [
                "icn_folder_selected",
                "icn_camera_selected",
                "icn_report_selected"
            ],
            unselectedImageNames: [
                "icn_folder_unselected",
                "icn_camera_unselected",
                "icn_report_unselected"
            ]
        )
        
        // CaptureStore
        public var captureStore = CaptureFeature.State()
    }
    
    public enum Action {
        case onAppear
        case setDestination(Destination)
        
        case mainTabaction(MainFeature.Action)
        case captureTabaction(CaptureFeature.Action)
    }
    
    public enum Destination {
        case login
        case main
    }
    
    private let logger: (String) -> Void
    
    public init(
        logger: @escaping @Sendable (String) -> Void
    ) {
        self.logger = logger
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.captureStore, action: \.captureTabaction) {
            CaptureFeature { log in ClLogger.message(message: log) }
        }
        
        Scope(state: \.tabMainStore, action: \.mainTabaction) { MainFeature() }
        
        Reduce { state, action in
            logger("\(Self.self) action :: \(action)")
            switch action {
            case .onAppear:
                // auto login fetch
                state.destination = .login
                return .none
                
            case .setDestination(let destination):
                state.destination = destination
                return .none
                
            case .mainTabaction:
                return .none
                
            case .captureTabaction(let action):
                switch action {
                case .startRecording:
                    return .run { send in
                        await send(.mainTabaction(.startRecord))
                    }
                default: return .none
                }
            }
        }
    }
}

