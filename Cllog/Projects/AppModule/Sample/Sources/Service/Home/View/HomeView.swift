//
//  HomeView.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import MainFeature
import LoginFeature
import CaptureFeature

import ComposableArchitecture

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
        WithViewStore(store, observe: { $0 }) { viewStore in
            switch viewStore.state.destination {
            case .login:
                LoginView(
                    on: on,
                    store: Store(
                        initialState: LoginFeature.State()) {
                            LoginFeature()
                        }
                ).onAppear {
                    viewStore.send(.setDestination(.main))
                }
                
            case .main:
                MainView(
                    on: on,
                    tabViews: [
                        Text("1"),
                        captureView,
                        Text("3")
                    ], store: Store(
                        initialState: MainFeature.State(
                            tabTitles: [],
                            selectedImageNames: [
                                "icn_folder_selected",
                                "icn_camera_selected",
                                "icn_report_selected"
                            ],
                            unselectedImageNames: [
                                "icn_folder_unselected",
                                "icn_camera_unselected",
                                "icn_report_unselected"
                            ]
                        ), reducer: {
                        MainFeature()
                    }))
                
            case .none:
                // Intro, splash
                Text("Splash")
                    .onAppear {
                        viewStore.send(.onAppear)
                    }
            }
        }
    }
    
    @ViewBuilder
    private var captureView: some View {
        CaptureView(
            on: on,
            store: Store(
                initialState: CaptureFeature.State(),
                reducer: {
                    CaptureFeature { log in
                        ClLogger.message(
                            level: .debug,
                            message: log
                        )
                    }
                }
            )
        )
    }
}
