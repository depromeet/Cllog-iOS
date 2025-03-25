//
//  AttemptFeature.swift
//  FolderFeature
//
//  Created by soi on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import Domain
import FolderDomain
import DesignKit
import Shared
import Core

import ComposableArchitecture

@Reducer
public struct AttemptFeature {
    @Dependency(\.attemptUseCase) private var attemptUseCase
    @Dependency(\.cragUseCase) private var cragUseCase
    @Dependency(\.gradeUseCase) private var gradeUseCase
//    @Dependency(\.locationClient) var locationClient
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init(attemptId: Int) {
            self.attemptId = attemptId
        }
        
        @Presents var alert: AlertState<Action.Dialog>?
        
        let attemptId: Int
        var attempt: ReadAttempt?
        var videoURL: URL?
        let editActions = AttemptEditAction.allCases
        
        var selectedAction: AttemptEditAction?
        var stampPositions = [CGFloat]()
        
        var nearByCrags = [DesignCrag]()
        var selectedCragGrades = [Grade]()
        
        // 난이도 & 암장 수정 -> 연결되는 State
        var selectedEditCrag: Crag?
        var selectedEditGrade: Grade?
        var selectedEditCragGrades: [Grade]?
        
        var currentLatitude = 37.56440029816974
        var currentLongitude = 126.9774418506923
        
        // Bottom sheet
        var showEditAttemptBottomSheet = false
        var showCragBottomSheet = false
        var showGradeBottomSheet = false
        
        var dynamicSheetHeight: CGFloat {
            switch selectedAction {
            case .video:
                251
            case .result:
                230
            case .info:
                700
            case .delete:
                300
            case nil: 270
            }
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case alert(PresentationAction<Dialog>)
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case moreButtonTapped
        case moreActionTapped(_ action: AttemptEditAction)
        case videoTapped
        case stampTapped(id: Int)
        
        case onSplitPositionsCalculated(positions: [CGFloat])
        case getAttempt(attempt: ReadAttempt)
        case getNearByCrags(_ crags: [Crag])
        case getCragGrades(_ grades: [Grade])
//        case locationPermissionResponse(CLAuthorizationStatus)
        case updateLocation(latitude: Double, longitude: Double)
        
        // edit actions
        case onEditSheetDismissed
        case editBackButtonTapped
        case deleteActionTapped
        case editCragTapped
        case didTapSaveGradeTapped(id: Int?)
        case cancelEditCragTapped
        case saveEditCragTapped(crag: Crag)
        case attemptResultActionTapped(attempt: AttemptResult)
        case patchedResult(_ result: AttemptResult)
        case patchedInfo(_ grade: Grade?, crag: Crag?)
        case skipEditCragTapped
        case deletedAttempt
        
        @CasePathable
        public enum Dialog: Equatable {
            case cancel
            case delete
        }
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
//                Task {
//                    let authStatus = await locationClient.requestLocationPermission()
//                    
//                    switch authStatus {
//                    case .authorizedWhenInUse, .authorizedAlways:
//                        if let location = await locationClient.getCurrentLocation() {
////                            state.currentLatitude = location.latitude
////                            state.currentLongitude = location.longitude
//                            print("현재 위치: 위도 \(location.latitude), 경도 \(location.longitude)")
//                        } else {
//                            print("위치 정보를 가져오지 못했습니다.")
//                        }
//                        
//                    case .denied, .restricted:
//                        print("위치 권한이 거부되었습니다.")
//                    case .notDetermined:
//                        print("위치 권한이 아직 결정되지 않았습니다.")
//                    @unknown default:
//                        print("알 수 없는 권한 상태입니다.")
//                    }
//                }
                return fetchAttempt(state.attemptId)
            case .backButtonTapped:
                return .none
            case .shareButtonTapped:
                return .none
            case .moreButtonTapped:
                state.showEditAttemptBottomSheet = true
                return .none
            case .moreActionTapped(let action):
                switch action {
                case .video, .result:
                    state.selectedAction = action
                    return .none
                case .info:
                    if let currentCragId = state.attempt?.crag?.id {
                        return fetchGrades(cragId: currentCragId)
                    }
                    return fetchNearByCrags()
                case .delete:
                    return .send(.deleteActionTapped)
                }
            case .videoTapped:
                return .none
            case .stampTapped(let id):
                // TODO: Seek to video
                return .none
                
            case .onSplitPositionsCalculated(let positions):
                state.stampPositions = positions
                return .none
            case .getAttempt(let attempt):
                state.attempt = attempt
                state.videoURL = URL(fileURLWithPath: attempt.attempt.video.localPath)
                state.selectedEditCrag = state.attempt?.crag
                state.selectedEditGrade = attempt.grade
                return .none
                
            // MARK: Bottom Sheet
            case .editBackButtonTapped:
                state.selectedAction = nil
                return .none
                
            case .onEditSheetDismissed:
                state.selectedAction = nil
                return .none
                
            case .deleteActionTapped:
                state.showEditAttemptBottomSheet = false
                state.alert = AlertState {
                    TextState("영상 기록 삭제")
                } actions: {
                    ButtonState(action: .delete) {
                        TextState("삭제")
                    }
                    ButtonState(action: .cancel) {
                        TextState("취소")
                    }
                } message: {
                    TextState("기록을 삭제하면 복구가 어려워요.\n영상 기록을 삭제하시나요?")
                }
                return .none
                
            case .deletedAttempt:
                return .none
            case .didTapSaveGradeTapped(let id):
                let grade = state.selectedCragGrades.first(where: { $0.id == id })
                guard let currentAttempt = state.attempt else {
                    return .none
                }
                return patchInfo(
                    attempt: currentAttempt,
                    grade: grade,
                    crag: state.selectedEditCrag
                )
            case .editCragTapped:
                state.showGradeBottomSheet = false
                return fetchNearByCrags()
            case .attemptResultActionTapped(let newAction):
                guard let currentAttempt = state.attempt else {
                    return .none
                }
                return patchResult(attempt: currentAttempt, result: newAction)
            case .skipEditCragTapped:
                state.selectedEditCrag = state.attempt?.crag
                state.selectedEditCragGrades = nil
                state.showCragBottomSheet = false
                state.showGradeBottomSheet = true
                return .none
            case .saveEditCragTapped(let crag):
                state.selectedEditCrag = crag
                return fetchGrades(cragId: crag.id)
               
            case .patchedResult(let result):
                let newAttempt = state.attempt?.copyWith(result: result)
                state.showEditAttemptBottomSheet = false
                state.selectedAction = nil
                state.attempt = newAttempt
                state.selectedEditCrag = state.attempt?.crag
                state.selectedEditCragGrades = nil
                return .none
            case .patchedInfo(let grade, let crag):
                state.selectedEditGrade = grade
                state.selectedEditCrag = crag
                state.showEditAttemptBottomSheet = false
                state.showCragBottomSheet = false
                state.showGradeBottomSheet = false
                return .none
                
            case .getNearByCrags(let crags):
                state.nearByCrags = crags.map {
                    DesignCrag(id: $0.id, name: $0.name, address: $0.address)
                }
                state.showCragBottomSheet = true
                return .none
            case .getCragGrades(let grades):
                state.showGradeBottomSheet = true
                state.showCragBottomSheet = false
                state.selectedCragGrades = grades
                return .none
                
            case .alert(.presented(.cancel)):
                return .none
            case .alert(.presented(.delete)):
                return deleteAttempt(state.attemptId)
                
            default: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AttemptFeature {
    
    private func fetchAttempt(_ attemptId: Int) -> Effect<Action> {
        return .run { send in
            do {
                let attempt = try await attemptUseCase.execute(attemptId: attemptId)
                await send(.getAttempt(attempt: attempt))
            } catch {
                // TODO: show error message
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func deleteAttempt(_ attemptId: Int) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.delete(attemptId: attemptId)
                await send(.editBackButtonTapped)
            } catch  {
                // TODO: show error message
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func patchResult(attempt: ReadAttempt, result: AttemptResult) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.patchResult(attempt: attempt, result: result)
                await send(.patchedResult(result))
            } catch {
                // TODO: show error message
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchNearByCrags() -> Effect<Action> {
        return .run { send in
            do {
                let crags = try await cragUseCase.getCrags()
                await send(.getNearByCrags(crags))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchGrades(cragId: Int) -> Effect<Action> {
        return .run { send in
            do {
                let grades = try await gradeUseCase.getCragGrades(cragId: cragId)
                await send(.getCragGrades(grades))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func patchInfo(attempt: ReadAttempt, grade: Grade?, crag: Crag?) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.patchInfo(attempt: attempt, grade: grade, crag: crag)
                await send(.patchedInfo(grade, crag: crag))
            }
        }
    }
}

extension AttemptFeature {
    public enum AttemptEditAction: CaseIterable {
        case video
        case result
        case info
        case delete
        
        var title: String {
            switch self {
            case .video:    "영상/스탬프 편집"
            case .result:   "완등/실패 수정"
            case .info:     "암장 정보, 난이도 수정"
            case .delete:   "영상 기록 삭제"
            }
        }
        
        var leadingIcon: Image {
            switch self {
            case .video:    Image.clLogUI.cut
            case .result:   Image.clLogUI.tag
            case .info:     Image.clLogUI.location
            case .delete:   Image.clLogUI.delete
            }
        }
        
        var color: Color {
            switch self {
            case .video, .result, .info:
                Color.clLogUI.white
            case .delete:
                Color.clLogUI.fail
            }
        }
    }
}
