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
    private let store: StoreOf<AttemptFeature>
    
    // TODO: Feature로 이동
    @State var progressValue: Float = 0.5
    @State var splitXPositions: [CGFloat] = []
   
    public var body: some View {
        makeBodyView()
            .background(Color.clLogUI.gray800)
            .onAppear() {
                store.send(.onAppear)
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
                .onTapGesture {
                    print("재생 또는 정지")
                }
            
                PlayerProgressBar(
                    value: $progressValue,
                    splitItems: attempt.attempt.video.stamps.map { ProgressSplitItem(id: $0.id, position: $0.position) },
                    onSplitItemTapped: { stampId in
                        store.send(.stampTapped(id: stampId))
                    }
                )
        }
    }
    
    private func makeAttemptInfoView(_ attempt: ReadAttempt) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("TEST")
//            Text(attempt.date) // TODO: 서버 작업 후 추가
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
}
