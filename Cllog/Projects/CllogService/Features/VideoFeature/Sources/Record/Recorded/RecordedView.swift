//
//  RecordedView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import SwiftUI

// 내부 Module
import Shared
import DesignKit

// 외부 Module
import ComposableArchitecture

public struct RecordedView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<RecordedFeature>
    
    public init(
        on: UIViewController?,
        store: StoreOf<RecordedFeature>
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
    
    @ViewBuilder
    private var bodyView: some View {
#if targetEnvironment(simulator)
        Color.gray
            .ignoresSafeArea()
#else
        RecordedPlayPreview(viewModel: store.viewModel)
            .ignoresSafeArea()
#endif
        
        VStack(spacing: .zero, content: {
            headerActionsView
            Spacer()
            footerActionsView
        })
    }
    
    @ViewBuilder
    private var headerActionsView: some View {
        ZStack {
            HStack {
                Button(action: {
                    store.send(.close)
                }) {
                    Image.clLogUI.icn_close
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.clLogUI.gray500.opacity(0.5))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(store.duration)
                    .font(.h5)
                    .foregroundColor(.clLogUI.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.clLogUI.gray500.opacity(0.5))
                    .clipShape(Capsule())
                
                Spacer()
                
                // 오른쪽 버튼 (편집)
                Button(action: {
                    store.send(.editButtonTapped)
                }) {
                    Text("편집")
                        .font(.h5)
                        .foregroundColor(.clLogUI.white)
                        .frame(width: 40, height: 40)
                        .background(Color.clLogUI.gray500.opacity(0.5))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 64)
    }
    
    @ViewBuilder
    private var footerActionsView: some View {
        ZStack {
            Color.clLogUI.gray900
                .edgesIgnoringSafeArea(.bottom)
            
            VStack(spacing: .zero) {
                
                RecordProgressBar(progress: store.progress)
                
                Spacer()
                
                HStack(spacing: 7) {
                    Button(action: {
                        
                    }) {
                        Text("실패로 저장")
                            .font(.b1)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clLogUI.gray600)
                            .foregroundColor(.clLogUI.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("완등으로 저장")
                            .font(.b1)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clLogUI.white)
                            .foregroundColor(.clLogUI.gray800)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(height: 94)
    }
}
