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
        WithViewStore(store, observe: { $0 }) { viewStore in
            switch viewStore.state.destination {
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
                        Text("1"),
                        captureView,
                        Text("3")
                    ], store: Store(
                        initialState: MainFeature.State(),
                        reducer: {
                            MainFeature()
                        }
                    )
                )
                
            case .splash:
                // Intro, splash
                Text("Splash").onAppear {
                    store.send(.onAppear)
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
