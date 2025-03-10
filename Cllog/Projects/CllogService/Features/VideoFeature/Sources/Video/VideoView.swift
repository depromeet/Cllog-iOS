//
//  VideoView.swift
//  VideoFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import DesignKit

import ComposableArchitecture

public struct VideoView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<VideoFeature>
    
    public init(
        on: UIViewController?,
        store: StoreOf<VideoFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        
        switch store.viewState {
        case .normal:
            // 카메라 권한이 받기 전 화면
            Text("CaptureView")
                .onAppear {
                    store.send(.onAppear)
                }
            
        case .video:
            // 카메라 권한이 있는 상태
            recordingView
            
        case .noneVideoPermission:
            // 카메라 권한이 없는 상태
            Text("none video permission")
        }
        
    }
}

private extension VideoView {
    
    var recordingView: some View {
        ZStack {

            sessionView
                 .ignoresSafeArea()
             
             HStack(spacing: 16) {
                 Button(action: {

                 }) {
//                     Image.clLogUI.btn_flash_off
                 }
                 
                 Spacer()
             }
             .padding(.leading, 16)
             .padding(.top, 106)
             
             VStack {
                 
                 Spacer()
                 
                 RecodingButton(isRecoding: .init(get: {
                     store.isRecording
                 }, set: { newValue in
                     
                 }), onTapped: {
                     store.send(.onStartRecord)
                 }).padding(.bottom, 40)
             }
             .scaleEffect(store.isRecording ? 1.1 : 1)
         }
    }
    
    var sessionView: some View {
        ClLogSessionView()
            .ignoresSafeArea()
    }
}
