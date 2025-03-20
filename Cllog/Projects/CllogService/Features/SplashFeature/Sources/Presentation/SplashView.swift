//
//  SplashView.swift
//  SplashFeature
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct SplashView: View {
    private let store: StoreOf<SplashFeature>
    @State private var opacity: Double = 0
    
    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clLogUI.gray900)
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    opacity = 1
                } completion: {
                    store.send(.animationFinished)
                }
            }
    }
}

extension SplashView {
    private func makeBody() -> some View {
        ZStack(alignment: .center) {
            Image.clLogUI.clogLogo
                .resizable()
                .frame(width: 183 ,height: 106)
                .opacity(opacity)
        }
    }
}

#Preview {
    SplashView(store: .init(initialState: SplashFeature.State(), reducer: {
        SplashFeature()
    }))
}
