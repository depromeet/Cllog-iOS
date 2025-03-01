//
//  CaptureView.swift
//  CaptureFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import DesignKit

import ComposableArchitecture

public struct CaptureView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<CaptureFeature>
    
    public init(
        on: UIViewController?,
        store: StoreOf<CaptureFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {

                Color.gray
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 16) {
                        Button(action: {
//                            viewStore.send(.toggleFlash)
                        }) {
                            Image.clLogUI.btn_flash_off
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.top, 106)
                    
                    Spacer()
                    
                    Text("영상기록")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    Button(action: {
                        withAnimation { [viewStore]
                            viewStore.send(.startRecording)
                        }
                    }) {
                        ZStack {
                            Image.clLogUI.recording_off
                                .frame(width: 64, height: 64)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .animation(.easeInOut, value: viewStore.state.isRecording)
            .toolbar(viewStore.state.isRecording ? .hidden : .visible, for: .tabBar)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
