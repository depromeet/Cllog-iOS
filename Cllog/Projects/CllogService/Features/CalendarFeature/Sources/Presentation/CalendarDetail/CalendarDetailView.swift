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
    private let store: StoreOf<CalendarDetailFeature>
    
    public init(store: StoreOf<CalendarDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray800)
            .onAppear {
                store.send(.onAppear)
            }
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
        StoriesView(
            store: store.scope(state: \.storiesState, action: \.storiesAction)
        )
    }
}

#Preview {
    CalendarDetailView(
        store: .init(
            initialState: CalendarDetailFeature.State(storyId: 0),
            reducer: {
                CalendarDetailFeature()
            }
        )
    )
}
