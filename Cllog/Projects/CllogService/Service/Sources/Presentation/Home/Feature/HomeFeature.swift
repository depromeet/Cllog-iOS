//
//  HomeFeature.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Domain

import MainFeature
import VideoFeature

import ComposableArchitecture
import LoginFeature
import Shared


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
        public var login = LoginFeature.State()
        public var videoState = VideoFeature.State()
        public var recordState = RecordFeature.State()
    }
    
    public enum Action {
        case onAppear
        case loginAction(LoginFeature.Action)
        case loginCompleted
        
        case mainFeatureAction(MainFeature.Action)
        case videoFeatureAction(VideoFeature.Action)
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
        
        Scope(state: \.videoState, action: \.videoFeatureAction) {
            ClLogDI.container.resolve(VideoFeature.self)
        }
        
        Scope(state: \.recordState, action: \.recordFeatureAction) {
            ClLogDI.container.resolve(RecordFeature.self)
        }
        
        Scope(state: \.login, action: \.loginAction) {
            LoginFeature()
        }
        
        Reduce { state, action in
            logConsoleUseCase.executeInfo(label: "\(Self.self)", message: "action :: \(action)")
            switch action {
            case .onAppear:
                state.destination = checkLoginStatus() ? .main : .login
                return .none
                
            case .loginAction(.successLogin):
                state.destination = .main
                return .none
                
            case .loginAction:
                return .none
                
            case .loginCompleted:
                return .none
                
            case .mainFeatureAction(let action):
                return .none
                
            case .videoFeatureAction(let action):
                switch action {
                case .sendAction(let send):
                    switch send {
                    case .onRecord(let isRecord):
                        // 탭에서 전달되는 상태
                        state.isRecord = isRecord
                        return .run { [state] send in
                            await send(.mainFeatureAction(state.isRecord ? .startRecord : .stopRecord))
                            if state.isRecord == false {
                                await send(.videoFeatureAction(.onStopRecord))
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
                                .videoFeatureAction(
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

    
    func checkLoginStatus() -> Bool {
        // TODO: 로그인 여부 확인
        return false
    }
}

