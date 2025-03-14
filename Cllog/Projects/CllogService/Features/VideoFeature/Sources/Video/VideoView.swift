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
    
    private weak var on: UIViewController?
    private let store: StoreOf<VideoFeature>
    
    public init(
        on: UIViewController? = nil,
        store: StoreOf<VideoFeature>
    ) {
        self.on = on
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
            VideoPreview(camera: store.camerModel)
                .ignoresSafeArea()
            
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
