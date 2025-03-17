//
//  RecordedFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import ComposableArchitecture

@Reducer
public struct RecordedFeature {
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Dialog>?
        
        let fileName: String
        let path: URL
        var duration: String = ""
        let viewModel: RecordedPlayViewModel
        var progress: CGFloat = .zero
        
        public init(fileName: String, path: URL) {
            self.fileName = fileName
            self.path = path
            self.viewModel = RecordedPlayViewModel(videoURL: path)
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        
        case startListeningPlayTime
        case startListeningEndPlay
        
        case timerTicked(CMTime, CMTime)
        
        case editButtonTapped
        case moveEditRecord(URL)
        
        case pause
        case closeButtonTapped
        case close
        
        case successTapped
        case failtureTapped
        
        case alert(PresentationAction<Dialog>)
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
            case cancel
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduceCore)
            .ifLet(\.alert, action: \.alert)
    }
    
}

extension RecordedFeature {
    
    private func reduceCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.viewModel.play()
            return .merge(
                .send(.startListeningPlayTime),
                .send(.startListeningEndPlay)
            )
            
        case .startListeningEndPlay:
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await _ in viewModel.playEndAsyncStream {
                    _ = await viewModel.seek(.zero)
                    viewModel.play()
                }
            }.cancellable(id: "EndPlay", cancelInFlight: true)
            
        case .startListeningPlayTime:
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await (playTime, totalduration) in viewModel.playTimeAsyncStream {
                    await send(.timerTicked(playTime, totalduration))
                }
            }.cancellable(id: "PlayTime", cancelInFlight: true)
            
        case .timerTicked(let playTime, let duration):
            let totalTime = CGFloat(CMTimeGetSeconds(duration))
            let currentTime = CGFloat(CMTimeGetSeconds(playTime))
            state.duration = playTime.formatTimeInterval()
            state.progress = currentTime/totalTime
            return .none
            
        case .editButtonTapped:
            return .merge(
                .send(.moveEditRecord(state.path)),
                .send(.pause)
            )
            
        case .pause:
            state.viewModel.pause()
            return .none
            
        case .moveEditRecord:
            return .none
            
        case .closeButtonTapped:
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
            return .none
            
        case .close:
            return .none
            
        case .successTapped:
            return .none
        case .failtureTapped:
            return .none
            
        case .alert(.presented(.confirm)):
            print("확인")
            return .none
            
        case .alert(.presented(.cancel)):
            print("취소")
            return .none
        case .alert(.dismiss):
            return .none
        }
    }
}
