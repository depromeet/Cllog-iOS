//
//  MainFeature.swift
//  CllogService
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import SwiftUI

// 내부 Module
import Shared
import VideoFeature

// 외부 Module
import ComposableArchitecture

@Reducer
public struct MainFeature {
    
    @ObservableState
    public struct State: Equatable {

        // Main Tab State
        var selectedTab: Int = 0
        
        // Video Tab State
        var vidoeTabState: VideoFeature.State = .init()
        
        // Record State
        var recordState: RecordHomeFeature.State?
        
        var isRecording: Bool = false
    }
    
    public enum Action: Equatable {
        // Main Tab Action
        case selectedTab(Int)
        
        // Video Tab Action
        case videoTabAction(VideoFeature.Action)
        
        // RecordTabbar Action
        case recordFeatureAction(RecordHomeFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.vidoeTabState, action: \.videoTabAction) {
            ClLogDI.container.resolve(VideoFeature.self)!
        }
        
        Reduce(reducerCore)
            .ifLet(\.recordState, action: \.recordFeatureAction) {
                ClLogDI.container.resolve(RecordHomeFeature.self)!
            }
    }
}

private extension MainFeature {
    
    /// Main Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Main Action
    /// - Returns: Effect
    func reducerCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .selectedTab(let index):
            // 탭 선택 시 전달 되는 Action
            return .merge(
                // 각 탭 Feature에 전달
                // folder, report도 전달하기 위해서 merge
                .send(.videoTabAction(.selectedTab(index)))
            )
            
        case .videoTabAction(let action):
            // 비디오 화면 - Action
            return videoCore(&state, action)
            
        case .recordFeatureAction(let action):
            // 녹화 화면 - Action
            return recordCore(&state, action)
        }
    }
}

private extension MainFeature {
    
    /// Record Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Record Action
    /// - Returns: Effect
    func recordCore(
        _ state: inout State,
        _ action: RecordHomeFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .recordEnd:
            state.recordState = nil
            state.isRecording = false
            return .run { send in
                await send(.videoTabAction(.onStartSession))
            }
        default:
            return .none
        }
    }
}

private extension MainFeature {
    
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Video Action
    /// - Returns: Effect
    func videoCore(
        _ state: inout State,
        _ action: VideoFeature.Action
    ) -> Effect<Action> {
        switch action {
            // 탭
        case .onStartRecord:
            withAnimation(.easeInOut(duration: 0.3)) {
                state.isRecording = true
                // 영상 촬영 시작
                state.recordState = .init()
            }
            return .none
        default:
            return .none
        }
    }
}
