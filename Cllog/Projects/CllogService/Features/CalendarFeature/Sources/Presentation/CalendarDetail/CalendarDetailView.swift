//
//  CalendarDetailView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct CalendarDetailView: View {
    private let calendarColumns = Array(repeating: GridItem(.flexible(), spacing: 18), count: 2)
    private let store: StoreOf<CalendarDetailFeature>
    
    public init(store: StoreOf<CalendarDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray800)
    }
}

extension CalendarDetailView {
    func makeBody() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            ScrollView {
                makeContent()
                    .padding(16)
            }
        }
    }
    
    func makeAppBar() -> some View {
        AppBar {
            Button {
                
            } label: {
                Image.clLogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clLogUI.white)
            }

        } rightContent: {
            HStack(spacing: 20) {
                Button {
                    
                } label: {
                    Image.clLogUI.share
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
                Button {
                    
                } label: {
                    Image.clLogUI.dotVertical
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
            }
        }
    }
    
    func makeContent() -> some View {
        VStack(spacing: 20) {
            userInfoView()
            problemListView()
            Spacer()
        }
    }
    
    func userInfoView() -> some View {
        UserInfoView(
            type: .detail,
            store: store.scope(state: \.userInfoState, action: \.userInfoAction)
        )
    }
    
    func problemListView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(.red)
                    .frame(width: 16, height: 16)
                
                Text("문제1")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.white)
            }
            
            LazyVGrid(columns: calendarColumns, spacing: 11) {
                ForEach(0..<5, id: \.self) { _ in
                    ThumbnailView(
                        imageURLString: "",
                        thumbnailType: .calendar,
                        challengeResult: .complete,
                        levelName: "",
                        levelColor: .black,
                        time: "00:00:00"
                    )
                }
            }
        }
    }
}

#Preview {
    CalendarDetailView(
        store: .init(
            initialState: CalendarDetailFeature.State(),
            reducer: {
                CalendarDetailFeature()
            }
        )
    )
}
