//
//  RecordFeature.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import Domain
import VideoDomain

import ComposableArchitecture

@Reducer
public struct RecordFeature {
    
    private let videoUseCase: VideoUseCase
    private let logConsoleUsecase: LogConsoleUseCase
    
    public let sessionViewModel: any ClLogSessionViewModelInterface
    
    public init(
        videoUseCase: VideoUseCase,
        sessionViewModel: any ClLogSessionViewModelInterface,
        logConsoleUsecase: LogConsoleUseCase
    ) {
        self.videoUseCase = videoUseCase
        self.sessionViewModel = sessionViewModel
        self.logConsoleUsecase = logConsoleUsecase
    }
    
    @ObservableState
    public struct State: Equatable {
        var viewState: ViewState?
        var isRecord: Bool = false
        var fileURL: URL?
        var totalTime: TimeInterval = .zero
        var recordDuration: String = "00:00:00"
        
        var progress: CGFloat = 0
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case onStartRecord
        case onStopRecord
        case onClose
        
        case fileOutput(filePath: URL, error: Error?, totalTime: TimeInterval)
        case updatePlayTime(String)
        case updatePlayCurrentTime(CMTime)
        
        case test(filePath: URL)
        
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
            
            case .fileOutput(let filePath, let error, let totalTime):
                if let error {
                    
                } else {
//                    state.fileURL = filePath
                    state.totalTime = totalTime
//                    state.recordDuration = "00:00:00"
////                    state.viewState = .recorded(fileURL: filePath)
                    
                }
                return .run { send in
                    do {
                        guard let fileURL = try await videoUseCase.execute(loadName: "3E371F56-4860-4D70-807E-89C1A9774304.mov") else {
                            return
                        }
                        await send(.test(filePath: fileURL))
                    } catch {
                        
                    }
                }
            case .test(let filePath):
                state.fileURL = filePath
//                state.totalTime = totalTime
                state.recordDuration = "00:00:00"
                state.viewState = .recorded(fileURL: filePath)
                return .none
                
            case .updatePlayTime(let updateTime):
                state.recordDuration = updateTime
                return .none
                
            case .updatePlayCurrentTime(let currentTime):
                let totalTime = CGFloat(state.totalTime)
                let currentTime = CGFloat(CMTimeGetSeconds(currentTime))
                state.progress = currentTime/totalTime
                return .none
                
            case .editVideo:
                return .none
                
            case .climbSaveSuccess:
                guard let fileURL = state.fileURL else { return .none }
                return .run { [videoUseCase] send in
                    do {
                        try await videoUseCase.execute(saveFile: fileURL)
                    } catch {
                        print("error: \(error)")
                    }
//                    try? await videoUseCase.execute(fileURL: fileURL)
                }
                
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
