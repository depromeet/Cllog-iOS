//
//  VideoFeature.swift
//  VideoFeature
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Shared

import ComposableArchitecture
import VideoDomain
import DesignKit

@Reducer
public struct VideoFeature {
    
    @Dependency(\.logConsole) var log
    @Dependency(\.videoPermission) var permissionUseCase
    @Dependency(\.gradeUseCase) var gradeUseCase
    
    @ObservableState
    public struct State: Equatable {
        // View State
        var viewState: ViewState = .normal
        
        // 카메라를 컨드롤하는 Model
        var cameraModel: VideoPreviewViewModel = .init()
        
        // 저장된 난이도가 있는지 확인
        var grade: SavedGrade?
        
        // 저장된 스토리가 있는지 확인
        var count: Int = 0
        
        var showSelectGradeView = false
        
        var grades: [Grade] = []
        var selectedGrade: DesignGrade?
        
        public init() {}
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        
        case updateViewState(ViewState)
        
        // 탭바가 클릭 되는 경우 해당 index가 전달
        case selectedTab(Int)
        
        case onStartSession
        
        case onStopSession
        
        // Video 화면에서 촬영 버튼을 클릭시 전달
        case onStartRecord
        
        // 스토리 종료
        case endedStoryTapped
        
        // 폴더 버튼
        case folderTapped
        
        // 다음 문제
        case nextProblemTapped
        
        // 난이도 정보 조회
        case fetchedGrade(grades: [Grade])
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
        BindingReducer()
        
        Reduce(videoCore)
    }
}

private extension VideoFeature {
    
    func videoCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding(_):
            return .none
        case .onAppear:
            state.count = VideoDataManager.attemptCount
            state.grade = VideoDataManager.savedGrade
            
            return .run { [permissionUseCase] send in
                do {
                    try await permissionUseCase.execute()
                    await send(.updateViewState(.video))
                    
                    // 저장된 암장 Id 있는 경우 난이도 업데이트
                    if let cragId = VideoDataManager.cragId {
                        // TODO: 오류처리
                        let grades = try? await gradeUseCase.getCragGrades(cragId: cragId)
                        await send(.fetchedGrade(grades: grades ?? []))
                    }
                } catch {
                    await send(.updateViewState(.noneVideoPermission))
                }
            }
            
        case .updateViewState(let viewState):
            state.viewState = viewState
            return .none
            
        case .onStartSession:
            state.count = VideoDataManager.attemptCount
            state.cameraModel.startSession()
            return .none
            
        case .onStopSession:
            state.cameraModel.stopSession()
            return .none
            
        case .onStartRecord:
            return .merge(
                .send(.onStopSession)
            )
            
        case .selectedTab(let index):
            guard state.viewState == .video else {
                state.cameraModel.stopSession()
                return .none
            }
            index == 1 ? state.cameraModel.startSession() : state.cameraModel.stopSession()
            return .none
            
        case .endedStoryTapped:
            VideoDataManager.clear()
            return .none
            
        case .folderTapped:
            return .none
            
        case .nextProblemTapped:
            state.showSelectGradeView = true
            return .none
            
        case .fetchedGrade(let grades):
            state.grades = grades
            return .none
        }
    }
}
