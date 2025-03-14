//
//  VideoFeature.swift
//  VideoFeature
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Shared

import ComposableArchitecture

@Reducer
public struct VideoFeature {
    
    @Dependency(\.logConsole) var log
    @Dependency(\.videoPermission) var permissionUseCase
    
    @ObservableState
    public struct State: Equatable {
        // View State
        var viewState: ViewState = .normal
        
        // 카메라를 컨드롤하는 Model
        var camerModel: VideoPreviewViewModel = .init()
        
        public init() {}
    }
    
    public enum Action: Equatable {
        
        case onAppear
        
        case updateViewState(ViewState)
        
        // 탭바가 클릭 되는 경우 해당 index가 전달
        case selectedTab(Int)
        
        case onStartSession
        
        case onStopSession
        
        // Video 화면에서 촬영 버튼을 클릭시 전달
        case onStartRecord
    }
    
    public enum ViewState {
        // 아직 권한을 체크하지 않는 상태
        case normal
        // 카메라이 없는 상태
        case noneVideoPermission
        // 카메라 권한이 있는 상태
        case video
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce(videoCore)
    }
}

private extension VideoFeature {
    
    func videoCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { [permissionUseCase] send in
                do {
                    try await permissionUseCase.execute()
                    await send(.updateViewState(.video))
                } catch {
                    await send(.updateViewState(.noneVideoPermission))
                }
            }
            
        case .updateViewState(let viewState):
            state.viewState = viewState
            return .none
            
        case .onStartSession:
            state.camerModel.startSession()
            return .none
            
        case .onStopSession:
            state.camerModel.stopSession()
            return .none
            
        case .onStartRecord:
            return .merge(
                .send(.onStopSession)
            )
            
        case .selectedTab(let index):
            guard state.viewState == .video else {
                state.camerModel.stopSession()
                return .none
            }
            index == 1 ? state.camerModel.startSession() : state.camerModel.stopSession()
            return .none
        }
    }
}
