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
    @Bindable private var store: StoreOf<VideoFeature>
    
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
            Text("")
            
        case .noneVideoPermission:
            Text("카메라 권한을 허용해주세요")
            
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
            VideoPreview(camera: store.cameraModel)
                .ignoresSafeArea()
            #else
            Color.clLogUI.gray100
                .ignoresSafeArea()
            #endif
            
            VStack(spacing: .zero) {
                
                if store.count > 0 {
                    HStack(alignment: .center) {
                        
                        if let grade = store.grade {
                            LevelChip(name: grade.name, color: .init(hex: grade.hexCode))
                        }
                        
                        Spacer()
                        
                        Button {
                            store.send(.endedStoryTapped)
                        } label: {
                            Text("종료")
                                .font(.h5)
                                .foregroundColor(.clLogUI.white)
                                .frame(width: 40, height: 40)
                                .background(Color.clLogUI.gray500.opacity(0.5))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
                
                Color.clear
                    .frame(height: 64)
                
                HStack(spacing: .zero) {
                    
                    // TODO: 카메라 기능 옵션
                    VStack {
                        Button {
                            
                        } label: {
                            Image.clLogUI.flashOff
                                .renderingMode(.template)
                                .foregroundColor(.clLogUI.white)
                                .frame(width: 40, height: 40)
                                .background(Color.clLogUI.gray500.opacity(0.5))
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            
                        } label: {
                            Text("9:16")
                                .font(.h5)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.clLogUI.white)
                                .background(Color.clLogUI.gray500.opacity(0.5))
                                .clipShape(Capsule())
                        }
                        
                        Button {
                            
                        } label: {
                            Text("1x")
                                .font(.h5)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.clLogUI.white)
                                .background(Color.clLogUI.gray500.opacity(0.5))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 42)
                    .padding(.leading, 16)
                    .hidden()
                    
                    Spacer()
                }
                .hidden()
                
                Spacer()
                
                HStack(alignment: .center) {
                    if store.count > 0 {
                        FolderButton(count: $store.count) {
                            store.send(.folderTapped)
                        }
                    }
                    
                    Spacer()
                    
                    RecodingButton(isRecoding: .init(
                        get: { false },
                        set: { newValue in }
                    ), onTapped: {
                        store.send(.onStartRecord)
                    })
                    
                    Spacer()
                    if store.count > 0 {
                        NextProblemButton {
                            store.send(.nextProblemTapped)
                        }
                    }
                }
                .padding(.horizontal, 42)
                .padding(.bottom, 40)
            }
        }
    }
}
