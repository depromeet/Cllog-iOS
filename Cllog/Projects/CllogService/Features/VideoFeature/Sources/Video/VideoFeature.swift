//
//  VideoFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI

import Domain
import VideoDomain

import ComposableArchitecture

@Reducer
public struct VideoFeature {
    
    private let logConsoleUseCase: LogConsoleUseCase
    private let permissionUseCase: VideoPermissionUseCase
    private let videoUseCase: VideoUseCase
    
    @ObservableState
    public struct State: Equatable {
        
        public var destination: Destination? = nil
        public var viewState: ViewState = .normal
        
        public var isRecording: Bool = false
        
        public init() {}
        
    }
    
    public enum Action {
        case onAppear
        case excuteVideo
        case noneExcuteCaptue
        
        case onStartRecord
        case onStopRecord
        
        case sendAction(Action.Send)
        
        public enum Send {
            // 레코드 상태를 전달
            case onRecord(Bool)
        }
        
    }
    
    public enum ViewState {
        case normal // 아직 권한을 체크하지 않는 상태
        case noneVideoPermission // 카메라이 없는 상태
        case video // 카메라 권한이 있는 상태
    }
    
    public enum Destination {
        case main
    }
    
    public init (
        logConsoleUseCase: LogConsoleUseCase,
        permissionUseCase: VideoPermissionUseCase,
        videoUseCase: VideoUseCase
    ) {
        self.logConsoleUseCase = logConsoleUseCase
        self.permissionUseCase = permissionUseCase
        self.videoUseCase = videoUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        try await permissionUseCase.execute()
                        await send(.excuteVideo)
                    } catch {
                        await send(.noneExcuteCaptue)
                    }
                }
                
            case .excuteVideo:
                state.viewState = .video
                return .none
                
            case .noneExcuteCaptue:
                state.viewState = .noneVideoPermission
                return .none
                
            case .onStartRecord:
                withAnimation(.easeInOut(duration: 0.3)) {
                    state.isRecording = true
                }
                
                return .run { [state] send in
                    await send(.sendAction(.onRecord(state.isRecording)))
                }
                
            case .onStopRecord:
                withAnimation(.easeInOut(duration: 0.3)) {
                    state.isRecording = false
                }
                
                return .none
                
            case .sendAction:
                // 상위로 이벤트 전달 - 동작 x
                return .none
            }
        }
    }
}
