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
    private let attempt = Attempt(
        date: "25.02.08 FRI",
        grade: Grade(name: "파랑", hexCode: 0x5E7CFF),
        result: .complete,
        recordedTime: "00:00:30",
        crag: Crag(name: "클라이밍파크 강남점", address: "강남")
    )
    
    public var body: some View {
        makeBodyView()
    }
    
    public init() {}
}

extension AttemptView {
    private func makeBodyView() -> some View {
        VStack {
            makeChipView()
               
            // TODO: 동영상 재생 화면
            RoundedRectangle(cornerRadius: 6)
                .padding(.vertical, 12)
                .padding(.horizontal, 12)
                
            
            makeAttemptInfoView()
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clLogUI.gray800)
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
        return LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 79, maximum: 82), spacing: 6)],
            alignment: .leading,
            spacing: 6
        ) {
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
            }
        }
    }
}
