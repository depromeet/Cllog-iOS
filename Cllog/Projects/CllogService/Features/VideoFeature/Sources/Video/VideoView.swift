//
//  VideoView.swift
//  VideoFeature
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import UIKit
import SwiftUI

// 내부 Module
import DesignKit

// 외부 Module
import ComposableArchitecture

public struct VideoView: View {
    private let store: StoreOf<VideoFeature>
    
    public init(
        store: StoreOf<VideoFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onAppear {
                store.send(.onAppear)
            }
    }
}

private extension VideoView {
    
    @ViewBuilder
    var bodyView: some View {
        switch store.viewState {
        case .normal:
            Text("normal")
            
        case .noneVideoPermission:
            Text("noneVideoPermission")
            
        case .video:
            camerView
                .onAppear {
                    store.send(.onStartSession)
                }
        }
    }
}

private extension VideoView {
    
    var camerView: some View {
        ZStack {
            #if !targetEnvironment(simulator)
            VideoPreview(camera: store.camerModel)
                .ignoresSafeArea()
            #else
            Color.clLogUI.gray100
                .ignoresSafeArea()
            #endif
            VStack(spacing: .zero) {
                
                Spacer()
                
                RecodingButton(isRecoding: .init(
                    get: { false },
                    set: { newValue in }
                ), onTapped: {
                    store.send(.onStartRecord)
                })
                .padding(.bottom, 40)
            }
        }
    }
}
