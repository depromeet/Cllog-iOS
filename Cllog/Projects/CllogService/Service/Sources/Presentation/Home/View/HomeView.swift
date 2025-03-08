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
import CaptureFeature

import ComposableArchitecture
import LoginDomain

struct HomeView: View {
    
    private weak var on: UIViewController?
    
    private let store: StoreOf<HomeFeature>
    
    init(
        on: UIViewController,
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
                        store: .init(initialState: FolderTabFeature.State(), reducer: {
                            return FolderTabFeature()
                        }), folderView: FolderView(store: .init(initialState: FolderFeature.State(), reducer: {
                            FolderFeature()
                        })), calendarView: CalendarView(store: .init(initialState: CalendarFeature.State(), reducer: {
                            CalendarFeature()
                        }))),
                    captureView,
                    Text("3")
                ], overlayerView: RecordView(
                    on: on,
                    store: store.scope(state: \.recordState, action: \.recordFeatureAction)
                ), store:
                    store.scope(state: \.mainState, action: \.mainFeatureAction))
        case .none:
            // Intro, splash
            Text("Splash")
                .onAppear {
                    store.send(.onAppear)
                }
        }
    }
    
    @ViewBuilder
    private var captureView: some View {
        CaptureView(
            on: on,
            store: store.scope(state: \.captureState, action: \.captureFeatureAction)
        )
    }
}
