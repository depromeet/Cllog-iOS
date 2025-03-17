//
//  VideoEditFeature.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import ComposableArchitecture

// TODO: 스탬프 시간 추가, 코드 위치 이동
struct Stamp: Identifiable, Equatable {
    let id: Double
    let xPos: CGFloat
    let isValid: Bool
    
    init(xPos: CGFloat, isValid: Bool) {
        self.id = Double(xPos)
        self.xPos = xPos
        self.isValid = isValid
    }
    
    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
        lhs.id == rhs.id
    }
}

@Reducer
public struct VideoEditFeature {
    
    public init() {}
    
    enum Constants {
        static let totalTrimmingWidth = UIScreen.main.bounds.width - 74
        static let playHeadWidth: CGFloat = 5
    }
    
    @ObservableState
    public struct State: Equatable {
        var currentTimeString: String = "00:00"
        var isPlaying: Bool = false
        var playheadPosition: CGFloat = 0
        var duration: Double = 0
        var stampList: [Stamp] = []
        var popedStampList: [Stamp] = []
        var trimStartPosition: CGFloat = 0
        var trimEndPosition: CGFloat = Constants.totalTrimmingWidth
        var isVideoReady: Bool = false
        let videoURL: URL
        
        public init(videoURL: URL) {
            self.videoURL = videoURL
        }
    }
    
    public enum Action: Equatable {
        case didTapStamp
        case didTapPlayPause
        case didTapUndoStamp
        case didTapRedoStamp
        case updatePlayHead(newPosition: CGFloat)
        case updateTrimStartPosition(position: CGFloat)
        case updateTrimEndPosition(position: CGFloat)
        case playerResponse(PlayerAction)
        case dismiss
        case complete
        case onAppear
        
        public enum PlayerAction: Equatable {
            case assetLoaded(duration: Double)
            case playbackStatusChanged(isPlaying: Bool)
            case timeUpdated(currentTime: Double)
            case playerReady
            case seekCompleted
        }
    }
    
    @Dependency(\.avPlayerClient) var avPlayerClient
    @Dependency(\.dismiss) var dismiss
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.trimEndPosition = Constants.totalTrimmingWidth
                
                return .merge(
                    avPlayerClient.initialize(state.videoURL)
                        .map { .playerResponse($0) },
                    
                    avPlayerClient.addPeriodicTimeObserver()
                        .map { .playerResponse($0) }
                )
            case .didTapStamp:
                state.stampList.append(Stamp(xPos: state.playheadPosition, isValid: isStampValid(position: state.playheadPosition, state: state)))
                return .none
            case .didTapPlayPause:
                state.isPlaying.toggle()
                
                if state.isPlaying {
                    // 플레이헤드가 트리밍 범위 밖이면 시작 지점으로 이동
                    if state.playheadPosition < state.trimStartPosition || state.playheadPosition > state.trimEndPosition {
                        let screenWidth = Constants.totalTrimmingWidth
                        let trimStartTime = (state.trimStartPosition / screenWidth) * state.duration
                        
                        state.playheadPosition = state.trimStartPosition
                        
                        return .run { send in
                            await avPlayerClient.seek(trimStartTime)
                            await avPlayerClient.play()
                            await send(.playerResponse(.playbackStatusChanged(isPlaying: true)))
                        }
                    } else {
                        return .run { _ in
                            await avPlayerClient.play()
                        }
                    }
                } else {
                    return .run { _ in
                        await avPlayerClient.pause()
                    }
                }
            case .didTapUndoStamp:
                guard let poppedStamp = state.stampList.popLast() else { return .none }
                state.popedStampList.append(poppedStamp)
                return .none
            case .didTapRedoStamp:
                guard let poppedStamp = state.popedStampList.popLast() else { return .none }
                state.stampList.append(poppedStamp)
                return .none
            case let .updatePlayHead(newPosition):
                // 플레이헤드 위치가 트리밍 범위 내에 있도록 제한
                let constrainedPosition = min(max(newPosition, state.trimStartPosition), state.trimEndPosition)
                state.playheadPosition = constrainedPosition
                
                // 플레이헤드 위치에 해당하는 시간으로 비디오 탐색
                let screenWidth = Constants.totalTrimmingWidth
                let time = (constrainedPosition / screenWidth) * state.duration
                
                return .run { _ in
                    await avPlayerClient.seek(time)
                }
            case let .updateTrimStartPosition(position):
                state.trimStartPosition = position
                state.playheadPosition = max(state.playheadPosition, position)
                updateStampValidity(state: &state)
                return .none
            case let .updateTrimEndPosition(position):
                state.trimEndPosition = position
                state.playheadPosition = min(state.playheadPosition, position - Constants.playHeadWidth)
                updateStampValidity(state: &state)
                return .none
            case let .playerResponse(playerAction):
                switch playerAction {
                case let .assetLoaded(duration):
                    state.duration = duration
                    return .none
                case let .playbackStatusChanged(isPlaying):
                    state.isPlaying = isPlaying
                    return .none
                case let .timeUpdated(currentTime):
                    state.currentTimeString = formatTime(currentTime)
                    
                    // 플레이헤드 위치 계산 및 업데이트
                    let screenWidth = Constants.totalTrimmingWidth
                    let newPosition = (currentTime / state.duration) * screenWidth
                    
                    // 트리밍 영역을 벗어난 경우 처리
                    if newPosition < state.trimStartPosition && state.isPlaying || newPosition > state.trimEndPosition - Constants.playHeadWidth && state.isPlaying {
                        let trimStartTime = (state.trimStartPosition / screenWidth) * state.duration
                        let trimStartPos = state.trimStartPosition
                        state.isPlaying = false
                        
                        return .run { send in
                            await avPlayerClient.pause()
                            await send(.playerResponse(.playbackStatusChanged(isPlaying: false)))
                            await avPlayerClient.seek(trimStartTime)
                            await MainActor.run {
                                send(.updatePlayHead(newPosition: trimStartPos))
                            }
                        }
                    } else {
                        // 정상 범위 내에서는 플레이헤드 업데이트
                        state.playheadPosition = min(newPosition, state.trimEndPosition - Constants.playHeadWidth)
                    }
                    return .none
                case .playerReady:
                    state.isVideoReady = true
                    return .none
                case .seekCompleted:
                    return .none
                }
            case .dismiss:
                return .run { _ in
                    await dismiss()
                }
            case .complete:
                // TODO: 완료 처리 구현
                return .none
            }
        }
        .onChange(of: \.trimStartPosition) { oldValue, newValue in
            Reduce { state, action in
                if action == .updateTrimStartPosition(position: newValue) {
                    state.playheadPosition = max(state.playheadPosition, newValue)
                }
                return .none
            }
        }
        .onChange(of: \.trimEndPosition) { oldValue, newValue in
            Reduce { state, action in
                if action == .updateTrimEndPosition(position: newValue) {
                    state.playheadPosition = min(state.playheadPosition, newValue)
                }
                return .none
            }
        }
    }
    
    private func updateStampValidity(state: inout State) {
        state.stampList = state.stampList.map { stamp in
            Stamp(xPos: stamp.xPos, isValid: isStampValid(position: stamp.xPos, state: state))
        }
    }
    
    private func isStampValid(position: CGFloat, state: State) -> Bool {
        return position >= state.trimStartPosition && position <= state.trimEndPosition
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds) / 60
        let seconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
