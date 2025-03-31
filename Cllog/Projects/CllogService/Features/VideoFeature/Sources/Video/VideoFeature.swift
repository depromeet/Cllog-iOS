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
    @Dependency(\.registerProblemUseCase) var registerProblemUseCase
    
    @ObservableState
    public struct State: Equatable {
        // View State
        var viewState: ViewState = .normal
        
        // 카메라를 컨드롤하는 Model
        var cameraModel: VideoPreviewViewModel = .init()
        
        // 저장된 난이도가 있는지 확인
        var grade: SavedGrade?
        var cragId: Int?
        
        // 저장된 스토리가 있는지 확인
        var count: Int = 0
        
        var showSelectGradeView = false
        
        var grades: [Grade] = []
        var selectedGrade: DesignGrade?
        var doNotSaveGrade = false
        
        // 폴더 및 종료 바텀시트
        var showProblemCheckCompleteBottomSheet = false
        var problemCheckCompleteBottomSheetState: ProblemCheckCompleteBottomSheetFeature.State?
        
        var showFolderBottomSheet = false
        var problemCheckState: ProblemCheckFeature.State?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
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
        
        // 다음 문제 백그라운드 뷰 선택
        case backgroundViewTapped
        
        case selectNextGrade(grade: DesignGrade?)
        
        // 난이도 정보 조회
        case fetchedGrade(grades: [Grade])
        
        case problemCheckCompleteBottomSheetAction(ProblemCheckCompleteBottomSheetFeature.Action)
        case problemCheckAction(ProblemCheckFeature.Action)
        case recordCompleted(Int?)
        
        case registerProblemSuccess(Int)
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
            .ifLet(\.problemCheckCompleteBottomSheetState, action: \.problemCheckCompleteBottomSheetAction) {
                ProblemCheckCompleteBottomSheetFeature()
            }
            .ifLet(\.problemCheckState, action: \.problemCheckAction) {
                ProblemCheckFeature()
            }
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
            state.cragId = VideoDataManager.cragId
            
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
            guard let storyId = VideoDataManager.savedStory?.storyId else { return .none }
            state.showProblemCheckCompleteBottomSheet = true
            state.problemCheckCompleteBottomSheetState = .init(storyId: storyId)
            return .none
            
        case .folderTapped:
            guard let storyId = VideoDataManager.savedStory?.storyId else { return .none }
            state.showFolderBottomSheet = true
            state.problemCheckState = .init(storyId: storyId)
            return .none
            
        case .nextProblemTapped:
            state.showSelectGradeView = true
            guard state.cragId != VideoDataManager.cragId else {
                return .none
            }
            
            guard let cragId = VideoDataManager.cragId else {
                // 저장된 암장이 없는 경우, 난이도 선택 불가능
                // 바로 영상 편집
                return .none
            }
            return .run { send in
                do {
                    let grades = try await gradeUseCase.getCragGrades(cragId: cragId)
                    await send(.fetchedGrade(grades: grades))
                } catch {
                    // 에러 처리
                    await send(.fetchedGrade(grades: []))
                }
            }
        case .backgroundViewTapped:
            state.showSelectGradeView = false
            return .none
            
        case .fetchedGrade(let grades):
            state.grades = grades
            
            if let previousGradeId = VideoDataManager.savedGrade?.id {
                let currentGrade = grades.first(where: { $0.id == previousGradeId })
                    .map { SavedGrade(id: $0.id, name: $0.name, hexCode: $0.hexCode) }
                VideoDataManager.savedGrade = currentGrade
            } else {
                // 저장된 난이도 정보가 없는 경우 난이도 정보 없음으로 초기화
                VideoDataManager.savedGrade = nil
                state.selectedGrade = nil
            }
            return .none
            
        case .selectNextGrade(let designGrade):
            state.showSelectGradeView = false
            let grade = state.grades.first(where: { $0.id == designGrade?.id })
            if let grade {
                let savedGrade = SavedGrade(
                    id: grade.id,
                    name: grade.name,
                    hexCode: grade.hexCode
                )
                state.grade = savedGrade
                VideoDataManager.savedGrade = savedGrade
            } else {
                state.grade = nil
                VideoDataManager.savedGrade = nil
            }
            state.selectedGrade = designGrade
            state.doNotSaveGrade = false
            return registerProblem(gradeId: grade?.id)
            
        case .problemCheckCompleteBottomSheetAction(let action):
            return problemCheckCompleteBottomSheetCore(&state, action)
            
        case .recordCompleted:
            return .none
            
        case .problemCheckAction(let action):
            return problemCheckCore(&state, action)
            
        case .registerProblemSuccess(let problemId):
            VideoDataManager.changeProblemId(problemId)
            return .none
        }
    }
    
    func problemCheckCompleteBottomSheetCore(
        _ state: inout State,
        _ action: ProblemCheckCompleteBottomSheetFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .finishTapped:
            guard let storyId = VideoDataManager.savedStory?.storyId else { return .none }
            VideoDataManager.clear()
            state.showProblemCheckCompleteBottomSheet = false
            state.count = 0
            return .send(.recordCompleted(storyId))
        default:
            return .none
        }
    }
    
    func problemCheckCore(
        _ state: inout State,
        _ action: ProblemCheckFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .deleteSuccess:
            VideoDataManager.attemptCount -= 1
            state.count = VideoDataManager.attemptCount
            
            if state.count == 0 {
                state.showFolderBottomSheet = false
                VideoDataManager.clear()
                return .send(.recordCompleted(nil))
            }
            return .none
        default:
            return .none
        }
    }
    
    private func registerProblem(gradeId: Int?) -> Effect<Action> {
        .run { send in
            guard let storyId = VideoDataManager.savedStory?.storyId else {
                return
            }
            let id = try await registerProblemUseCase.execute(storyId: storyId, gradeId: gradeId)
            await send(.registerProblemSuccess(id))
        }
    }
}
