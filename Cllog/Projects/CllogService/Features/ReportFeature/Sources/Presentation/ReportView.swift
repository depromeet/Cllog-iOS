//
//  ReportView.swift
//  ReportFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct ReportView: View {
    private let store: StoreOf<ReportFeature>
    
    public init(store: StoreOf<ReportFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray800)

    }
}

extension ReportView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            Spacer(minLength: 10)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    makeInformation()
                        .padding(.horizontal, 4)
                    
                    makeWorkoutDurationView()
                    makeCompletionStatsView()
                    makeChallengeView()
                    makeFavoriteCragView()
                    makeSaveAndSharedButton()
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func makeAppBar() -> some View {
        VStack(spacing: 0) {
            AppBar {
                Text("나의 클라이밍 리포트")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.gray10)
            } rightContent: {
                Button {
                    store.send(.settingTapped)
                } label: {
                    Image.clLogUI.setting
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
            }
        }
    }
    
    private func makeInformation() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("김클로그님,")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.primary)
                Spacer(minLength: 4)
                Text("최근 3개월동안 32일 클라이밍했어요")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.primary)
                Text("얼마나 열심히 도전했는지 확인해볼까요?")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
            }
            Spacer()
        }
    }
    
    private func makeWorkoutDurationView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("총 운동 시간")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("52:00:00")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.white)
            }
            .padding(24)
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                Image.clLogUI.clogLogo
                    .resizable()
                
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.clLogUI.gray700,
                            Color.clLogUI.gray700.opacity(0.0)
                        ]
                    ),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 73)
                .allowsHitTesting(false)
            }
            .frame(width: 164)
        }
        .background(Color.clLogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeCompletionStatsView() -> some View {
        HStack {
            VStack(alignment: .center) {
                Image.clLogUI.clogLogo
                    .resizable()
                    .frame(width: 64, height: 50)
                Spacer()
                Text("푼 문제")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("52")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clLogUI.gray600)
                .frame(height: 80)
            
            VStack(alignment: .center) {
                Image.clLogUI.clogLogo
                    .resizable()
                    .frame(width: 64, height: 50)
                Spacer()
                Text("시도 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("52")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clLogUI.gray600)
                .frame(height: 80)
            
            VStack(alignment: .center) {
                Image.clLogUI.clogLogo
                    .resizable()
                    .frame(width: 64, height: 50)
                Spacer()
                Text("완등률")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("78%")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.clLogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeChallengeView() -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("김클로그님의 가장 뿌듯했던 도전")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                
                Spacer(minLength: 4)
                
                Text("클라이밍 파크 강남점에서")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.gray10)
                HStack(spacing: 0) {
                    Text("노랑 ")
                        .font(.h3)
                        .foregroundStyle(Color.clLogUI.primary)
                    Text("문제를 ")
                        .font(.h3)
                        .foregroundStyle(Color.clLogUI.gray10)
                    Text("10번 ")
                        .font(.h3)
                        .foregroundStyle(Color.clLogUI.primary)
                    Text("도전해 완등했네요!")
                        .font(.h3)
                        .foregroundStyle(Color.clLogUI.gray10)
                    Spacer()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            
            Spacer(minLength: 16)
            
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<10, id: \.self) { _ in
                            ThumbnailView(
                                imageURLString: "https://dummyimage.com/600x400/000/fff",
                                thumbnailType: .calendar,
                                challengeResult: .complete,
                                time: "00:00:12"
                            )
                            .frame(width: 166, height: 166)
                        }
                    }
                }
                .padding(.vertical, 12)
                
                HStack {
                    Spacer()
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                Color.clLogUI.gray700,
                                Color.clLogUI.gray700.opacity(0.83),
                                Color.clLogUI.gray700.opacity(0.71),
                                Color.clLogUI.gray700.opacity(0.0),
                            ]
                        ),
                        startPoint: .trailing,
                        endPoint: .leading
                    )
                    .frame(width: 58)
                    .allowsHitTesting(false)
                }
            }
            .padding(.leading, 24)
            
            Spacer(minLength: 16)
        }
        .background(Color.clLogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeFavoriteCragView() -> some View {
        HStack {
            VStack(spacing: 8) {
                HStack {
                    Text("16회")
                        .font(.h5)
                        .foregroundStyle(Color.clLogUI.white)
                    Text("방문한 최애 암장")
                        .font(.h5)
                        .foregroundStyle(Color.clLogUI.gray400)
                }
                Text("더클라임 강남")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
            
            Spacer()
            
            ZStack(alignment: .bottom) {
                Image.clLogUI.clogLogo
                    .resizable()
                
                LinearGradient(
                    gradient: Gradient(
                        colors: [
                            Color.clLogUI.gray700,
                            Color.clLogUI.gray700.opacity(0.0)
                        ]
                    ),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: 62)
                .allowsHitTesting(false)
            }
            .frame(width: 164)
        }
        .background(Color.clLogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeSaveAndSharedButton() -> some View {
        Button {
            
        } label: {
            Text("저장 / 공유하기")
                .font(.b1)
                .foregroundStyle(Color.clLogUI.primary)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(Color.clLogUI.gray900)
                .cornerRadius(12, corners: .allCorners)
        }

    }
}
