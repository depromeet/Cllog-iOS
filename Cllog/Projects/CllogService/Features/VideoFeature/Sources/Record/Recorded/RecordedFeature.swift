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
        
        let fileName: String
        let elapsedTime: TimeInterval
        let path: URL
        let viewModel: RecordedPlayViewModel
        var duration: String = ""
        
        var progress: CGFloat = .zero
        
        public init(fileName: String, elapsedTime: TimeInterval, path: URL) {
            self.fileName = fileName
            self.elapsedTime = elapsedTime
            self.path = path
            self.viewModel = RecordedPlayViewModel(videoURL: path)
        }
    }
    
    public enum Action: Equatable {
        case onAppear
        
        case startListeningPlayTime
        case startListeningEndPlay
        
        case timerTicked(CMTime)
        
        case close
    }
    
    public var body: some ReducerOf<Self> {
        Reduce(reduceCore)
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
                for await playTime in viewModel.playTimeAsyncStream {
                    await send(.timerTicked(playTime))
                }
            }.cancellable(id: "PlayTime", cancelInFlight: true)
            
        case .timerTicked(let playTime):
            let totalTime = CGFloat(state.elapsedTime)
            let currentTime = CGFloat(CMTimeGetSeconds(playTime))
            state.duration = playTime.formatTimeInterval()
            state.progress = currentTime/totalTime
            return .none
            
        case .close:
            return .none
        }
    }
}
