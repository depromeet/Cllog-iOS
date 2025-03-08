//
//  RecordFeature.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Domain

import ComposableArchitecture

@Reducer
public struct RecordFeature {
    
    private let logConsoleUsecase: LogConsoleUseCase
    
    public init(
        logConsoleUsecase: LogConsoleUseCase
    ) {
        self.logConsoleUsecase = logConsoleUsecase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var viewState: ViewState = .recording
        public var isRecord: Bool = false
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case onStopRecord
        case onClose
        
        case sendAction(Action.Send)
        
        public enum Send {
            case closeRecord
        }
    }
    
    public enum ViewState {
        // 녹화중
        case recording
        // 녹화완료
        case recorded
        // 편집중
        case editing
        // 완료 -> 기존 탭으로 이동
        case completed
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .onStopRecord:
                return .none
                
            case .onClose:
                // 화면을 받을 때 발생
                return .run { send in
                    await send(.sendAction(.closeRecord))
                }
                
            case .sendAction:
                // 상위에서 받는 이벤트 - 동작 x
                return .none
            }
        }
    }
}
