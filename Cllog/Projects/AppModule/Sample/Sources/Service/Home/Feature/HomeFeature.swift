//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Domain

import MainFeature
import CaptureFeature

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    
    private let logConsoleUseCase: LogConsoleUseCase
    
    @ObservableState
    public struct State: Equatable {
        public var isRecord: Bool = false
        public var destination: Destination? = nil
        
        public var mainState = MainFeature.State(
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
        public var captureState = CaptureFeature.State()
        public var recordState = RecordFeature.State()
    }
    
    public enum Action {
        case onAppear
        case setDestination(Destination)
        
        case mainFeatureAction(MainFeature.Action)
        case captureFeatureAction(CaptureFeature.Action)
        case recordFeatureAction(RecordFeature.Action)
    }
    
    public enum Destination {
        case login
        case main
    }
    
    public init(
        logConsoleUseCase: any LogConsoleUseCase
    ) {
        self.logConsoleUseCase = logConsoleUseCase
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.mainState, action: \.mainFeatureAction) {
            ClLogDI.container.resolve(MainFeature.self)
        }
        
        Scope(state: \.captureState, action: \.captureFeatureAction) {
            ClLogDI.container.resolve(CaptureFeature.self)
        }
        
        Scope(state: \.recordState, action: \.recordFeatureAction) {
            ClLogDI.container.resolve(RecordFeature.self)
        }
        
        Reduce { state, action in
            logConsoleUseCase.executeInfo(label: "\(Self.self)", message: "action :: \(action)")
            switch action {
            case .onAppear:
                // auto login fetch
                state.destination = .login
                return .none
                
            case .setDestination(let destination):
                state.destination = destination
                return .none
                
            case .mainFeatureAction(let action):
                return .none
                
            case .captureFeatureAction(let action):
                switch action {
                case .sendAction(let send):
                    switch send {
                    case .onRecord(let isRecord):
                        // 탭에서 전달되는 상태
                        state.isRecord = isRecord
                        return .run { [state] send in
                            await send(.mainFeatureAction(state.isRecord ? .startRecord : .stopRecord))
                            if state.isRecord == false {
                                await send(.captureFeatureAction(.onStopRecord))
                            }
                        }
                    }
                default: return .none
                }
                
            case .recordFeatureAction(let action):
                switch action {
                case .sendAction(let send):
                    switch send {
                    case .closeRecord:
                        
                        return .run { send in
                            await send(
                                .captureFeatureAction(
                                    .sendAction(
                                        .onRecord(false)
                                    )
                                )
                            )
                        }
                    }
                default: return .none
                }
            }
            
        }
    }
}

