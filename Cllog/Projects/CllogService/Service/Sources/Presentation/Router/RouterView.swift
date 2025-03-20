//
//  CoordinatorView.swift
//  CllogService
//
//  Created by Junyoung Lee on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import CalendarFeature
import SettingFeature
import FolderFeature

public struct RouterView: View {
    @Bindable private var store: StoreOf<RouterFeature>
    
    public init(store: StoreOf<RouterFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStackStore(store.scope(state: \.path, action: \.path)) {
            RootView(
                store: store.scope(
                    state: \.rootState,
                    action: \.rootAction
                )
            )
            .navigationBarBackButtonHidden(true)
        } destination: { store in
            switch store.case {
            case .calendarDetail(let store):
                CalendarDetailView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .setting(let store):
                SettingView(store: store)
                    .navigationBarBackButtonHidden(true)
            case .attempt(let store):
                AttemptView(store: store)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    RouterView(
        store: .init(
            initialState: RouterFeature.State(),
            reducer: {
                RouterFeature()
            }
        )
    )
}
