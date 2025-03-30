//
//  AttemptView.swift
//  FolderFeature
//
//  Created by soi on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import FolderDomain
import DesignKit
import Shared
import Core

import ComposableArchitecture

public struct AttemptView: ViewProtocol {
    @Bindable private var store: StoreOf<AttemptFeature>
    
    public var body: some View {
        makeBodyView()
            .background(Color.clLogUI.gray800)
            .onAppear {
                store.send(.onAppear)
            }
            .showGradeBottomSheet(
                isPresented: $store.showGradeBottomSheet,
                cragName: store.selectedEditCrag?.name ?? "",
                grades: store.selectedCragGrades.map {
                    DesignGrade(
                        id: $0.id,
                        name: $0.name,
                        color: Color(hex: $0.hexCode)
                    )
                },
                didTapSaveButton: { newGrade in
                    store.send(.didTapSaveGradeTapped(id: newGrade?.id))
                },
                didTapCragTitleButton: {
                    store.send(.editCragTapped)
                }
            )
            .showCragBottomSheet(
                isPresented: $store.showCragBottomSheet,
                didTapSaveButton: { crag in
                    let selectedCrag = Crag(
                        id: crag.id,
                        name: crag.name,
                        address: crag.address
                    )
                    store.send(.saveEditCragTapped(crag: selectedCrag))
                },
                didTapSkipButton: {
                    store.send(.skipEditCragTapped)
                },
                didNearEnd: {
                    store.send(.loadMoreCrags)
                },
                matchesPattern: { crag, searchText in
                    crag.name.matchesPattern(searchText)
                },
                crags: $store.nearByCrags
            )
            .sheet(isPresented: $store.showEditAttemptBottomSheet) {
                makeEditAttemptBottomSheet()
                    .presentationDetents([.height(store.dynamicSheetHeight)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(Color.clLogUI.gray800)
                    .padding(16)
            }
            .presentDialog(
                $store.scope(state: \.alert, action: \.alert),
                style: .delete
            )
            .onChange(of: store.showEditAttemptBottomSheet) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    store.send(.onEditSheetDismissed)
                }
            }
    }
    
    public init(store: StoreOf<AttemptFeature>) {
        self.store = store
    }
}

extension AttemptView {
    private func makeBodyView() -> some View {
        VStack {
            makeAppBar()
            
            if let attempt = store.attempt {
                makeContentView(with: attempt)
            } else {
                makeLoadingView()
            }
        }
    }
    
    private func makeContentView(with attempt: ReadAttempt) -> some View {
        VStack(spacing: 0) {
            
            makeChipView(attempt)
            
            makeVideoView(attempt)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            
            makeAttemptInfoView(attempt)
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    private func makeLoadingView() -> some View {
        ZStack {
            Color.clLogUI.gray800
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: ClLogUI.gray500))
                .scaleEffect(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    }
    
    private func makeAppBar() -> some View {
        AppBar {
            Button {
                store.send(.backButtonTapped)
            } label: {
                Image.clLogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clLogUI.white)
            }
        } rightContent: {
            HStack(spacing: 20) {
                Button {
                    store.send(.shareButtonTapped)
                } label: {
                    Image.clLogUI.share
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
                Button {
                    store.send(.moreButtonTapped)
                } label: {
                    Image.clLogUI.dotVertical
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
            }
        }
    }
    
    private func makeChipView(_ attempt: ReadAttempt) -> some View {
        let result: ChallengeResult = attempt.result == .complete ? .complete : .fail
        return ScrollView(.horizontal) {
            HStack {
                Spacer()
                    .frame(width: 16)
                
                CompleteOrFailChip(
                    challengeResult: result,
                    isActive: true
                )
                
                if let grade = attempt.grade {
                    LevelChip(
                        name: grade.name,
                        color: Color(hex: grade.hexCode),
                        backgroundColor: .clLogUI.gray600
                    )
                }
                
                if let crag = attempt.crag {
                    Text(crag.name)
                        .font(.h5)
                        .foregroundStyle(Color.clLogUI.gray200)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(Color.clLogUI.gray600)
                        )
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    }
   
    private func makeVideoView(_ attempt: ReadAttempt) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(Color.clLogUI.dim)
            
            if let videoPath = store.videoURL {
                ZStack(alignment: .center) {
                    VideoPlayerView(
                        videoPath: videoPath,
                        isPlaying: $store.isPlaying,
                        currentProgress: $store.progress,
                        seekTime: $store.seekTime
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .onTapGesture {
                        store.send(.videoTapped)
                    }
                    
                    if store.showVideoControlButton {
                        
                        Button {
                            store.send(.videoControlTapped)
                        } label: {
                            let image = store.isPlaying ? Image.clLogUI.stopSmall : Image.clLogUI.playSmall
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 58, height: 58)
                        }
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: store.showVideoControlButton)
                    }
                }
            }
            
            PlayerProgressBar(
                duration: Double(attempt.attempt.video.durationMs / 1000),
                progress: CGFloat(store.progress),
                stampTimeList: attempt.attempt.video.stamps.map { Double($0.timeMs / 1000) }) { stampTime in
                print("### stampTime: \(stampTime)")
            }
        }
        .cornerRadius(6, corners: [.bottomLeft, .bottomRight])
    }
    
    private func makeAttemptInfoView(_ attempt: ReadAttempt) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(attempt.date)
                .font(.h1)
                .foregroundStyle(Color.clLogUI.white)
            
            Divider()
                .padding(.vertical, 12)
            
            Text("MY STAMP")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.primary)
            
            makeStampView(attempt.attempt.video.stamps)
                .padding(.top, 10)
        }
    }
    
    private func makeStampView(_ stamps: [AttemptStamp]) -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(stamps, id: \.self) { timeStamp in
                    HStack {
                        ClLogUI.stampSmall
                            .resizable()
                            .frame(width: 11, height: 15)
                            .foregroundStyle(Color.clLogUI.primary)
                        
                        Text(timeStamp.timeMs.msToTimeString)
                        
                    }
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray200)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color.clLogUI.gray600)
                    )
                    .onTapGesture {
                        store.send(.stampTapped(id: timeStamp.id))
                        print(timeStamp.id)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    }
    
    // MARK: - BottomSheet View
    private func makeEditAttemptBottomSheet() -> some View {
        ZStack {
            if store.selectedAction == nil {
                VStack(alignment: .leading) {
                    ForEach(store.editActions, id: \.self) { action in
                        Button {
                            store.send(.moreActionTapped(action))
                        } label: {
                            HStack(spacing: 10) {
                                action.leadingIcon
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(action.color)
                                
                                Text(action.title)
                                    .font(.h4)
                                    .foregroundStyle(action.color)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                        }
                    }
                }
                .padding(.horizontal, 16)
            } else {
                
                switch store.selectedAction {
//                case .video:
//                    Text("Video")
                case .result:
                    makeEditResultBottomSheet()
                case .info:
                    Text("info")
                case .delete:
                    Text("delete")
                case .none:
                    EmptyView()
                }
            }
        }
    }
    
    private func makeEditActionDetailView(for action: AttemptFeature.AttemptEditAction) -> some View {
        VStack {
            switch action {
//            case .video:
//                Text("Video")
            case .result:
                makeEditResultBottomSheet()
            case .info:
                Text("info")
            case .delete:
                Text("delete")
            }
        }
    }
    
    private func makeEditResultBottomSheet() -> some View {
        VStack(alignment: .leading) {
            Button {
                store.send(.editBackButtonTapped)
            } label: {
                HStack {
                    ClLogUI.back
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                    
                    Text("완등/실패")
                        .font(.h3)
                        .foregroundStyle(Color.clLogUI.white)
                }
            }
            
            Divider()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.clLogUI.gray600)
            
            ForEach(AttemptResult.allCases, id: \.self) { result in
                Button {
                    store.send(.attemptResultActionTapped(attempt: result))
                } label: {
                    Text(result.name)
                        .font(.h4)
                        .foregroundStyle(Color.clLogUI.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
