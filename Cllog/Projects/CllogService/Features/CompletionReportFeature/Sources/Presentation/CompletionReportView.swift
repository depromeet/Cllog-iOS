//
//  CompletionReportView.swift
//  CompletionReportFeature
//
//  Created by Junyoung on 3/31/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct CompletionReportView: View {
    @Bindable private var store: StoreOf<CompletionReportFeature>
    
    public init(store: StoreOf<CompletionReportFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray900)
            .onAppear {
                store.send(.onAppear)
            }
    }
}

extension CompletionReportView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            ScrollView(showsIndicators: false) {
                makeContent()
            }
        }
    }
    
    private func makeAppBar() -> some View {
        AppBar {
            Button {
                store.send(.finish)
            } label: {
                Image.clLogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clLogUI.white)
            }
        } rightContent: {
            Button {
                
            } label: {
                Image.clLogUI.share
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clLogUI.white)
            }
        }
        .background(Color.clLogUI.gray900)
    }
    
    private func makeContent() -> some View {
        VStack {
            makeCragName()
            Spacer(minLength: 20)
            makeThumbnail()
            Spacer(minLength: 20)
            totalExerciseTime()
            Spacer(minLength: 12)
            makeCompletionStatsView()
            Spacer(minLength: 12)
            makeBottomBotton()
            
        }
        .padding(16)
    }
    
    private func makeCragName() -> some View {
        HStack(spacing: 4) {
            Image.clLogUI.location
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.clLogUI.gray10)
            
            Text("\(store.summary.cragName ?? "암장 미등록")")
                .font(.h2)
                .foregroundStyle(Color.clLogUI.white)
            
            Spacer()
        }
    }
    
    private func makeThumbnail() -> some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: "https://fastly.picsum.photos/id/554/200/300.jpg?hmac=fYkNLoTqHRKUkIc3bZt_xMEb17s_BIRuuKTz8jb9ijs")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 343)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    Image.clLogUI.alert
                        .resizable()
                        .frame(height: 343)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                @unknown default:
                    EmptyView()
                }
            }
            
            HStack(spacing: 0) {
                Spacer()
                Image.clLogUI.clogLogo
                    .resizable()
                    .frame(width: 40, height: 24)
                    .foregroundStyle(Color.clLogUI.primary)
                
                Spacer(minLength: 24)
                
                Text("25.02.08 FRI")
                    .font(.h4)
                    .foregroundStyle(Color.clLogUI.primary)
                
                DividerView(.vertical, color: Color.clLogUI.primary)
                    .padding(.vertical, 5)
                
                Text(store.summary.totalDurationMs.msToTimeString)
                    .font(.h4)
                    .foregroundStyle(Color.clLogUI.primary)
                Spacer()
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 10)
            .background(Color.clLogUI.gray900.opacity(0.6))
            .frame(height: 44)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .padding(.bottom, 18)
            .padding(.horizontal, 21)
        }
    }
    
    private func totalExerciseTime() -> some View {
        VStack(alignment: .center) {
            Text("총 운동 시간")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray400)
            
            Text(store.summary.totalDurationMs.msToTimeString)
                .font(.h1)
                .foregroundStyle(Color.clLogUI.gray10)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.clLogUI.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeCompletionStatsView() -> some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("시도 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("\(store.summary.totalAttemptsCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clLogUI.gray600)
            
            VStack(alignment: .center) {
                Text("완등 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("\(store.summary.totalSuccessCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            
            DividerView(.vertical, color: Color.clLogUI.gray600)
            
            VStack(alignment: .center) {
                Text("실패 횟수")
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("\(store.summary.totalFailCount)")
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(16)
        .background(Color.clLogUI.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func makeBottomBotton() -> some View {
        GeneralButton("확인") {
            store.send(.finish)
        }
        .style(.white)
    }
}

#Preview {
    CompletionReportView(
        store: .init(
            initialState: CompletionReportFeature.State(storyId: 0),
            reducer: {
                CompletionReportFeature()
            }
        )
    )
}
