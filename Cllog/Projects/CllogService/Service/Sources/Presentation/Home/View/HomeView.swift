//
//  HomeView.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import FolderTabFeature
import FolderFeature
import CalendarFeature

import MainFeature
import LoginFeature
import VideoFeature

import ComposableArchitecture
import LoginDomain

struct HomeView: View {
    
    private weak var on: BaseViewController?
    
    private let store: StoreOf<HomeFeature>
    
    init(
        on: BaseViewController,
        store: StoreOf<HomeFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    var body: some View {
        switch store.destination {
        case .login:
            LoginView(
                on: on,
                store: store.scope(
                    state: \.login,
                    action: \.loginAction
                )
            )
        case .main:
            MainView(
                on: on,
                tabViews: [
                    FolderTabView(
                        store: store.scope(
                            state: \.folderTabState,
                            action: \.folderTabAction
                        ),
                        folderView: FolderView(
                            store: store.scope(
                                state: \.folderState,
                                action: \.folderAction
                            )
                        ),
                        calendarView: CalendarMainView(
                            store: store.scope(
                                state: \.calendarMainState,
                                action: \.calendarMainAction
                            )
                        )
                    ),
                    videoView,
                    Text("3")
                ],
                overlayerView: RecordView(
                    on: on,
                    store: store.scope(state: \.recordState, action: \.recordFeatureAction)
                ),
                store:
                    store.scope(state: \.mainState, action: \.mainFeatureAction)
            )
        case .calendarDetail(let storyId):
            CalendarDetailView(
                store: store.scope(
                    state: \.calendarDetailState,
                    action: \.calendarDetailAction
                )
            )
        case .none:
            // Intro, splash
            Text("Splash")
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
    
    @ViewBuilder
    private var videoView: some View {
        VideoView(
            on: on,
            store: store.scope(state: \.videoState, action: \.videoFeatureAction)
        )
    }
}
