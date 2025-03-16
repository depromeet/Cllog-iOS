//
//  HomeView.swift
//  Cllog
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import DesignKit

import LoginDomain
import LoginFeature

import ComposableArchitecture

struct RootView: View {
    
    private let store: StoreOf<RootFeature>
    
    init(
        store: StoreOf<RootFeature>
    ) {
        self.store = store
    }
    
    var body: some View {
       bodyView
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    private var bodyView: some View {
        ZStack {
            // 자동 로그인
            IfLetStore(store.scope(state: \.autoLoginState, action: \.autoLoginAction), then: AutoLoginView.init)
            
            // 로그인
            IfLetStore(store.scope(state: \.loginState, action: \.loginAction), then: LoginView.init)
            
            // 메인
            IfLetStore(store.scope(state: \.mainState, action: \.mainAction), then: { store in
                MainView(store: store)
            })
        }
    }
}
