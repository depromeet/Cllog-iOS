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
import FolderTabFeature
import FolderFeature
import CalendarFeature

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
        var recordState: RecordFeature.State?
        
        // FolderTab State
        var folderTabState: FolderTabFeature.State = .init()
        
        // Folder State
        var folderState: FolderFeature.State = .init()
        
        // CalendarMain State
        var calendarMainState: CalendarMainFeature.State = .init()
        
        // CalendarDetail State
        var calendarDetailState: CalendarDetailFeature.State = .init()
        
        var isRecording: Bool = false
        
        var pushToCalendarDeatil: Int?
    }
    
    public enum Action {
        // Main Tab Action
        case selectedTab(Int)
        
        // Video Tab Action
        case videoTabAction(VideoFeature.Action)
        
        // RecordTabbar Action
        case recordFeatureAction(RecordFeature.Action)
        
        // FolderTabFeature
        case folderTabAction(FolderTabFeature.Action)
        case folderAction(FolderFeature.Action)
        case calendarMainAction(CalendarMainFeature.Action)
        case calendarDetailAction(CalendarDetailFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        
        Scope(state: \.vidoeTabState, action: \.videoTabAction) {
            ClLogDI.container.resolve(VideoFeature.self)!
        }
        
        Scope(state: \.folderTabState, action: \.folderTabAction) {
            FolderTabFeature()
        }
        
        Scope(state: \.folderState, action: \.folderAction) {
            FolderFeature()
        }
        
        Scope(state: \.calendarMainState, action: \.calendarMainAction) {
            CalendarMainFeature()
        }
        
        Scope(state: \.calendarDetailState, action: \.calendarDetailAction) {
            CalendarDetailFeature()
        }
        
        Reduce(reducerCore)
            .ifLet(\.recordState, action: \.recordFeatureAction) {
                ClLogDI.container.resolve(RecordFeature.self)!
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
        case .folderTabAction(let action):
            // 폴더 탭 - Action
            return folderTabCore(&state, action)
        case .folderAction(let action):
            // 폴더 - Action
            return folderCore(&state, action)
        case .calendarMainAction(let action):
            // 캘린더 - Action
            return calendarMainCore(&state, action)
        case .calendarDetailAction(let action):
            return calendarDetailCore(&state, action)
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
        _ action: RecordFeature.Action
    ) -> Effect<Action> {
        return .none
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
            }
            // 영상 촬영 시작
            state.recordState = .init()
            return .none
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: FolderTab Action
    /// - Returns: Effect
    func folderTabCore(
        _ state: inout State,
        _ action: FolderTabFeature.Action
    ) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: Folder Action
    /// - Returns: Effect
    func folderCore(
        _ state: inout State,
        _ action: FolderFeature.Action
    ) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: FolderTab Action
    /// - Returns: Effect
    func calendarMainCore(
        _ state: inout State,
        _ action: CalendarMainFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .moveToCalendarDeatil(let storyId):
            // 캘린더 상세 페이지로 이동
            state.pushToCalendarDeatil = storyId
            return .none
        default:
            return .none
        }
    }
}

private extension MainFeature {
    /// Video Action
    /// - Parameters:
    ///   - state: 저장소
    ///   - action: FolderTab Action
    /// - Returns: Effect
    func calendarDetailCore(
        _ state: inout State,
        _ action: CalendarDetailFeature.Action
    ) -> Effect<Action> {
        switch action {
        default:
            return .none
        }
    }
}
