//
//  RecordingView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import UIKit
import SwiftUI

// 내부 Module
import DesignKit
import Shared

// 외부 Moduel
import ComposableArchitecture

public struct RecordingView: View {
    
    private weak var on: UIViewController? = nil
    private let store: StoreOf<RecordingFeature>
    
    public init(
        on: UIViewController? = nil,
        store: StoreOf<RecordingFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onAppear {
                store.send(.onAppear)
            }
            .debugFrameSize()
    }
    
    @ViewBuilder
    private var bodyView: some View {
        
        #if targetEnvironment(simulator)
        Color.gray
            .ignoresSafeArea()
        #else
        RecordingPlyPreview(viewModel: store.viewModel)
            .ignoresSafeArea()
        #endif
        
        VStack(spacing: .zero) {
            
            Text(store.elapsedTime.formatTimeInterval())
                .font(.h5)
                .foregroundColor(.clLogUI.white)
                .background(Color.clLogUI.gray500.opacity(0.5))
                .clipShape(Capsule())
                .padding(.horizontal, 5.5)
                .padding(.vertical, 9.5)
            
            Spacer()
            
            RecodingButton(isRecoding: .init(
                get: { true },
                set: { newValue in }
            ), onTapped: {
                store.send(.onStopRecording)
            }).padding(.bottom, 40)
        }
    }
}
