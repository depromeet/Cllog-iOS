//
//  RecordView.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

import DesignKit

import ComposableArchitecture

public struct RecordView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<RecordFeature>
    
    public init(
        on: UIViewController?,
        store: StoreOf<RecordFeature>
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

private extension RecordView {
    
    @ViewBuilder
    var bodyView: some View {
        ZStack {
            switch store.viewState {
            case .recording:
                recordView
                    .ignoresSafeArea()
                    .onAppear {
                        store.send(.onStartRecord)
                    }
                
            case .recorded(let fileURL):
                recoredView(fileURL: fileURL)
                
            case .editing:
                Text("")
                
            case .completed:
                Text("")
                
            case .none:
                Text("")
            }
        }
        .background(Color.black)
    }
}

// MARK: - Record
private extension RecordView {
    
    @ViewBuilder
    var recordView: some View {
        ClLogSessionView(isRecording: .init(get: {
            return store.isRecord
        }, set: { _ in
            
        }), fileOutputClousure: { fileURL, error in
            store.send(.fileOutput(filePath: fileURL, error: error))
        })
        
        VStack {
            
            Spacer()
            
            RecodingButton(isRecoding: .init(get: {
                return true
            }, set: { newValue in
                
            }), onTapped: {
                store.send(.onStopRecord)
            }).padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    func recoredView(fileURL: URL) -> some View {
        
        VideoPlayView(fileURL: fileURL)
            .ignoresSafeArea()
        
        VStack(alignment: .center, spacing: 0) {
            
            ZStack {
                HStack {
                    Button(action: {
                        store.send(.onClose)
                    }) {
                        Image.clLogUI.icn_close
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.clLogUI.gray500.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Spacer()

                    Text(store.recordDuration)
                        .font(.h5)
                        .foregroundColor(.clLogUI.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.clLogUI.gray500.opacity(0.5))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    // 오른쪽 버튼 (편집)
                    Button(action: {
                        store.send(.editVideo)
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
            
            Spacer()
            
            ZStack {
                Color.clLogUI.gray900
                    .edgesIgnoringSafeArea(.bottom)
                
                HStack(spacing: 7) {
                    Button(action: {
                        store.send(.climbSaveFailrue)
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
                        store.send(.climbSaveSuccess)
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
            .frame(height: 94)
        }
    }
}
