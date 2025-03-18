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
   
    private let attempt = Attempt(
        date: "25.02.08 FRI",
        grade: Grade(id: UUID().uuidString, name: "파랑", hexCode: "0x5E7CFF"),
        result: .complete,
        recordedTime: "00:00:30",
        crag: Crag(name: "클라이밍파크 강남점", address: "강남")
    )
    
    public var body: some View {
        makeBodyView()
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
            makeChipView()
            
            makeVideoView()
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            
            makeAttemptInfoView()
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clLogUI.gray800)
    }
    
    private func makeAppBar() -> some View {
        AppBar {
            Button {
                store.send(.didTapBackButton)
            } label: {
                Image.clLogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clLogUI.white)
            }
        } rightContent: {
            HStack(spacing: 20) {
                Button {
                    store.send(.didTapShareButton)
                } label: {
                    Image.clLogUI.share
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
                Button {
                    store.send(.didTapMoreButton)
                } label: {
                    Image.clLogUI.dotVertical
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
            }
        }
    }
    
    private func makeChipView() -> some View {
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
    
    private func makeVideoView() -> some View {
        
        return ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(Color.clLogUI.dim)
                .onTapGesture {
                    print("재생 또는 정지")
                }
            VStack(alignment: .leading, spacing: 3) {
                ZStack(alignment: .bottomLeading) {
                    ForEach(splitXPositions.indices, id: \.self) { index in
                        ClLogUI.stamp
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.clLogUI.primary)
                            .offset(x: splitXPositions[index] - CGFloat(15)) // 이미지 중앙 정렬을 위한 width/2
                    }
                }
                
                PlayerProgressBar(
                    value: $progressValue,
                    splitPositions: [0.2, 0.4, 0.7],
                    onSplitPositionsCalculated: { positions in
                        
                        splitXPositions = positions
                    }
                )
                .frame(height: 10)
            }
        }
    }
    
    private func makeAttemptInfoView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(attempt.date)
                .font(.h1)
                .foregroundStyle(Color.clLogUI.white)
            
            Divider()
                .padding(.vertical, 12)
            
            Text("MY STAMP")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.primary)
            
            makeStampView()
                .padding(.top, 10)
        }
    }
    
    private func makeStampView() -> some View {
        let mockStamps = [
            "00:00",
            "00:10",
            "00:40",
            "00:35",
            "00:24",
        ]
        return ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(mockStamps, id: \.self) { timeStamp in
                    HStack {
                        ClLogUI.stampSmall
                            .resizable()
                            .frame(width: 11, height: 15)
                            .foregroundStyle(Color.clLogUI.primary)
                        
                        Text(timeStamp)
                        
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
                        store.send(.didTapStampView(id: timeStamp)) // TODO: ID 또는 시간
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    }
}
