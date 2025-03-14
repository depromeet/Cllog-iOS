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

struct HomeView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<HomeFeature>
    
    init(
        on: BaseViewController,
        store: StoreOf<HomeFeature>
    ) {
        self.on = on
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
                .debugFrameSize()
            
            // 로그인
            IfLetStore(store.scope(state: \.loginState, action: \.loginAction), then: LoginView.init)
                .debugFrameSize()
            
            // 메인
            IfLetStore(store.scope(state: \.mainState, action: \.mainAction), then: { [weak on] store in
                MainView(on: on, store: store)
            })
            .debugFrameSize()
        }
    }
}
