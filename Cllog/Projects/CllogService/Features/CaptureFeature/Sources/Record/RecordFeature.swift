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
    
    public let sessionViewModel: any ClLogSessionViewModelInterface
    
    public init(
        sessionViewModel: any ClLogSessionViewModelInterface,
        logConsoleUsecase: LogConsoleUseCase
    ) {
        self.sessionViewModel = sessionViewModel
        self.logConsoleUsecase = logConsoleUsecase
    }
    
    @ObservableState
    public struct State: Equatable {
        public var viewState: ViewState?
        public var isRecord: Bool = false
        
        public var recordDuration: String = "00:01:21"
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case onStartRecord
        case onStopRecord
        case onClose
        
        case fileOutput(filePath: URL, error: Error?)
        
        case editVideo
        
        case climbSaveSuccess // 완등 성공으로 저장
        case climbSaveFailrue // 완등 실패로 저장
        
        case sendAction(Action.Send)
        
        public enum Send {
            case closeRecord
        }
    }
    
    public enum ViewState: Equatable {
        // 녹화중
        case recording
        // 녹화완료
        case recorded(fileURL: URL)
        // 편집중
        case editing
        // 완료 -> 기존 탭으로 이동
        case completed
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.viewState = .recording
                return .none
                
            case .onStartRecord:
                state.isRecord = true
                return .none
                
            case .onStopRecord:
                state.isRecord = false
                return .none
            
            case .fileOutput(let filePath, let error):
                if let error {
                    
                } else {
                    state.viewState = .recorded(fileURL: filePath)
                }
                return .none
                
            case .editVideo:
                return .none
                
            case .climbSaveSuccess:
                return .none
                
            case .climbSaveFailrue:
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
