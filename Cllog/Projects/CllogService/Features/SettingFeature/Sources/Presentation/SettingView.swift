//
//  SettingView.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct SettingView: View {
    private let store: StoreOf<SettingFeature>
    
    public init(store: StoreOf<SettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray800)
    }
}

extension SettingView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            AppBar(title: "설정") {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image.clLogUI.back
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
                
            } rightContent: {}
            
            Spacer()
        }
    }
}

#Preview {
    SettingView(
        store: .init(
            initialState: SettingFeature.State(),
            reducer: {
                SettingFeature()
            }
        )
    )
}
