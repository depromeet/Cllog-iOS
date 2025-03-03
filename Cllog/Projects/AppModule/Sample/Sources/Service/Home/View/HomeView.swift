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
        switch store.state.destination {
        case .login:
            LoginView(
                on: on,
                store: Store(
                    initialState: LoginFeature.State()
                ) {
                    ClLogDI.container.resolve(LoginFeature.self)!
                }
            ).onAppear {
                store.send(.setDestination(.main))
            }
            
        case .main:
            MainView(
                on: on,
                tabViews: [
                    Text("1"),
                    captureView,
                    Text("3")
                ],
                overlayerView: Text("123"),
                store: Store(initialState: MainFeature.State(
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
                    ClLogDI.container.resolve(MainFeature.self)
                }))
            
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
            store: Store(
                initialState: CaptureFeature.State(),
                reducer: {
                    ClLogDI.container.resolve(CaptureFeature.self)
                }
            )
        )
    }
}
