//
//  RecordedFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import DesignKit
import VideoDomain

import ComposableArchitecture
import UIKit

@Reducer
public struct RecordedFeature {
    
    @Dependency(\.videoUseCase) var videoUseCase
    @Dependency(\.saveStoryUseCase) var saveStoryUseCase
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Dialog>?
        @Presents var cragAlert: AlertState<Action.Dialog>?
        
        let fileName: String
        let path: URL
        var duration: String = ""
        let viewModel: RecordedPlayViewModel
        var progress: CGFloat = .zero
        
        var image: UIImage?
        
        var climbingResult: ClimbingResult?
        
        var selectedDesignCrag: DesignCrag?
        
        var designGrades: [DesignGrade] = [
            .init(id: 0, name: "블루", color: .init(hex: "#0000ff")),
            .init(id: 0, name: "블루", color: .init(hex: "#0000ff")),
            .init(id: 0, name: "블루", color: .init(hex: "#0000ff"))
        ]
        
        // bottomSheet
        var showSelectCragBottomSheet = false
        var designCrag: [DesignCrag] = [
            DesignCrag(id: 0, name: "강남점", address: "서울 강남구"),
            DesignCrag(id: 0, name: "홍대점", address: "서울 마포구"),
            DesignCrag(id: 0, name: "신촌점", address: "서울 서대문구")
        ]
        
        var showSelectCragDifficultyBottomSheet = false
        
        public enum ClimbingResult: Sendable {
            case success
            case failture
        }
        
        public init(fileName: String, path: URL) {
            self.fileName = fileName
            self.path = path
            self.viewModel = RecordedPlayViewModel(videoURL: path)
        }
    }
    
    public enum Action: BindableAction, Equatable {
        
        // life cycle
        case onAppear
        case upload(type: UploadType, image: UIImage)
        
        // recordCore
        case startListeningPlayTime
        case startListeningEndPlay
        case timerTicked(CMTime, CMTime)
        case play
        case pause
        case closeButtonTapped
        
        // navigationCore
        case editButtonTapped
        case moveEditRecord(URL)
        case close
        
        // savebuttonCore
        case successTapped
        case failureTapped
        
        // alertCore
        case alert(PresentationAction<Dialog>)
        case cragAlert(PresentationAction<Dialog>)
        case binding(BindingAction<State>)
        
        // cragBottomSheetCore
        case cragBottomSheetAction(Bool)
        case cragNameSkipButtonTapped
        case cragName(keyWord: String)
        case cragSaveButtonTapped(DesignCrag)
        
        case gradeBottomSheetShow(DesignCrag)
        case gradeSaveButtonTapped(DesignGrade?)
        case gradeTapCragTitleButton
        
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
            case cancel
        }
        
        public enum UploadType: Equatable {
            case success
            case failture
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(recordedCore)
            .ifLet(\.alert, action: \.alert)
            .ifLet(\.cragAlert, action: \.cragAlert)
    }
    
}

extension RecordedFeature {
    
    private func recordedCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .onAppear:
            return .merge(
                // 영상 시작
                .send(.play),
                // 타이머 시작
                .send(.startListeningPlayTime),
                // 영상 end 이벤트
                .send(.startListeningEndPlay)
            )
        
        case .binding(let action):
            return .none
            
        case .upload(type: let type, image: let image):
            return .none
            
        case .play, .pause, .startListeningPlayTime, .startListeningEndPlay, .timerTicked:
            return recordCore(&state, action)
            
        case .closeButtonTapped, .editButtonTapped, .moveEditRecord, .close:
            return navigationCore(&state, action)
            
        case .successTapped, .failureTapped:
            return saveButtonCore(&state, action)
            
        case .alert, .cragAlert:
            return alertCore(&state, action)
            
        case .cragBottomSheetAction, .cragSaveButtonTapped, .cragNameSkipButtonTapped, .cragName, .gradeBottomSheetShow, .gradeSaveButtonTapped, .gradeTapCragTitleButton:
            return cragBottomSheetCore(&state, action)
        }
    }
    
    private func recordCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .play:
            // 영상 시작
            state.viewModel.play()
            return .none
        case .pause:
            // 영상 정지
            state.viewModel.pause()
            return .none
        case .startListeningPlayTime:
            // 타이머 시작
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await (playTime, totalduration) in viewModel.playTimeAsyncStream {
                    await send(.timerTicked(playTime, totalduration))
                }
            }.cancellable(id: "PlayTime", cancelInFlight: true)
        case .startListeningEndPlay:
            // 영상 end 이벤트
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await _ in viewModel.playEndAsyncStream {
                    _ = await viewModel.seek(.zero)
                    viewModel.play()
                }
            }.cancellable(id: "EndPlay", cancelInFlight: true)
            
        case .timerTicked(let playTime, let duration):
            // 영상 시간 표시 및 progress
            let totalTime = CGFloat(CMTimeGetSeconds(duration))
            let currentTime = CGFloat(CMTimeGetSeconds(playTime))
            state.duration = playTime.formatTimeInterval()
            state.progress = currentTime/totalTime
            return .none
            
        default:
            return .none
        }
    }
    
    private func navigationCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .closeButtonTapped:
            // close 버튼 클릭 Action
            state.alert = AlertState {
                TextState("기록 저장 취소")
            } actions: {
                ButtonState(action: .cancel) {
                    TextState("계속 편집")
                }
                ButtonState(action: .confirm) {
                    TextState("저장 안함")
                }
            } message: {
                TextState("이 페이지를 나가면 촬영하신 영상이 저장되지 않아요")
            }
            return .run { send in
                await send(.pause)
            }
            
        case .editButtonTapped:
            // 편집 버튼 클릭 Action
            return .merge(
                .send(.moveEditRecord(state.path)),
                .send(.pause)
            )
            
            
        case .close:
            // 화면 닫힘
            return .none
        default:
            return .none
        }
    }
    
    private func saveButtonCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .successTapped:
            // 성공하기로 저장 버튼 클릭
            state.climbingResult = .success
            state.showSelectCragBottomSheet = true
            return .run { send in
                await send(.pause)
            }
            
        case .failureTapped:
            // 실패하기로 저장 버튼 클릭
            state.climbingResult = .success
            state.showSelectCragBottomSheet = true
            return .run { send in
                await send(.pause)
            }
            
        default:
            return .none
        }
    }
    
    private func alertCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .alert(.presented(.confirm)):
            // close 다이얼로그  저장안함
            return .send(.close)
            
        case .alert(.presented(.cancel)):
            // close 다이얼로그  계속 편집
            return .none
            
        case .alert(.dismiss):
            // close 다이얼로그 닫힘
            return .none
            
        case .cragAlert(.presented(.confirm)):
            state.showSelectCragDifficultyBottomSheet = true
            // 암장정보 건너뛰기 alert - 저장안함
            return .none
            
        case .cragAlert(.presented(.cancel)):
            // 암장정보 건너뛰기 alert - 계속 편집
            state.showSelectCragBottomSheet = true
            return .none
            
        case .cragAlert(.dismiss):
            // 암장정보 건너뛰기 alert - 닫힘
            return .none
            
        default:
            return .none
        }
    }
    
    private func cragBottomSheetCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .cragBottomSheetAction(let isPresent):
            // 암장 선택 바텀시트 - present newValue
            state.showSelectCragBottomSheet = isPresent
            return .none
            
        case .cragSaveButtonTapped(let designCrag):
            // 암장 선택 바텀시트 - 저장버튼 클릭
            state.showSelectCragBottomSheet = false
            
            // 준영: 암장을 정보를 요청하고 넣어주어야함
            state.selectedDesignCrag = designCrag
            return .run { [designCrag] send in
                await send(.gradeBottomSheetShow(designCrag))
            }
            
        case .cragNameSkipButtonTapped:
            // 암장 선택 바텀시트 - 스킵 버튼 클릭
            state.showSelectCragBottomSheet = false
            state.cragAlert = AlertState {
                TextState("암장 정보 입력 건너뛰기")
            } actions: {
                ButtonState(action: .cancel) {
                    TextState("계속 편집")
                }
                ButtonState(action: .confirm) {
                    TextState("저장 안함")
                }
            } message: {
                TextState("임장 입력을 하지 않으면 기록은 가능하지만,\n암장 관련 정보는 저장되지 않아요")
            }
            return .none
            
        case .cragName(let keyWord):
            // 암장 등급을 검색할떄 호출
            return .none
        case .gradeBottomSheetShow(let designCrag):
            // 암장 등급을 보여주기 위해서 호출되는 값
            state.showSelectCragDifficultyBottomSheet = true
            return .none
            
        case .gradeTapCragTitleButton:
            // 암장 등급 바텀시트
            return .none
            
        case .gradeSaveButtonTapped(let designGrade):
            // 암장 등급 바텀시트에서 등급을 저장하기 버튼을 누르면 오는 이벤트
            // TODO: 최종 저장 버튼
            return .run { [state] send in
                let request = StoryRequest(
                    cragId: nil, // 암장 ID
                    problem: ProblemRequest(gradeId: 0), // 난이도 ID
                    attempt: AttemptRequest(
                        status: "SUCCESS",
                        problemId: nil,
                        video: VideoRequest(
                            localPath: state.path.absoluteString,
                            thumbnailUrl: "",
                            durationMs: (Int(state.duration) ?? 0) * 1000,
                            stamps: [
                                StampRequest(timeMs: 0) // 타임 스탬프
                            ]
                        )
                    ),
                    memo: nil
                )
                
                let response = try await saveStoryUseCase.execute(request)
                try await videoUseCase.execute(saveFile: state.path)
            }
            
        default: return .none
        }
    }
    
    private func gradeBttomSheetCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        return .none
    }
}

extension UIImage {
    func resizedPNGData(targetSizeInBytes: Int = 1_000_000) -> Data? {
        guard var currentData = self.pngData() else { return nil }
        
        // 이미지의 해상도를 줄여서 targetSizeInBytes 미만이 될 때까지 반복
        var currentImage = self
        let scaleFactor: CGFloat = 0.9
        
        while currentData.count > targetSizeInBytes,
              currentImage.size.width > 100, currentImage.size.height > 100 {
            let newSize = CGSize(width: currentImage.size.width * scaleFactor,
                                 height: currentImage.size.height * scaleFactor)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            currentImage.draw(in: CGRect(origin: .zero, size: newSize))
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                break
            }
            UIGraphicsEndImageContext()
            
            currentImage = resizedImage
            if let data = currentImage.pngData() {
                currentData = data
            } else {
                break
            }
        }
        
        return currentData.count <= targetSizeInBytes ? currentData : nil
    }
}
