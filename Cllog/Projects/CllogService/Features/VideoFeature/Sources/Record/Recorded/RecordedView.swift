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
import Core

// 외부 Module
import ComposableArchitecture

public struct RecordedView: View {
    
    private weak var on: UIViewController?

    @Bindable private var store: StoreOf<RecordedFeature>
    
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
            .presentDialog($store.scope(state: \.alert, action: \.alert), style: .default)
            .showCragBottomSheet(
                isPresented: .init(get: {
                    store.showSelectCragBottomSheet
                }, set: { newValue in
                    store.send(.cragBottomSheetAction(newValue))
                }),
                didTapSaveButton: { designCrag in
                    store.send(.cragSaveButtonTapped(designCrag))
                }, didTapSkipButton: {
                    store.send(.cragNameSkipButtonTapped)
                }, didNearEnd: {
                    store.send(.loadMoreCrags)
                }, matchesPattern: { crag, searchText in
                    crag.name.matchesPattern(searchText)
                }, crags: $store.designCrags
            )
            .presentDialog($store.scope(state: \.cragAlert, action: \.cragAlert))
            .showGradeBottomSheet(
                isPresented: $store.showSelectCragDifficultyBottomSheet,
                cragName: store.selectedDesignCrag?.name ?? "",
                grades: store.grades.map {
                    DesignGrade(id: $0.id, name: $0.name, color: .init(hex: $0.hexCode))
                },
                didTapSaveButton: { designGrade in
                    store.send(.gradeSaveButtonTapped(designGrade))
                }, didTapCragTitleButton: {
                    store.send(.gradeTapCragTitleButton)
                })
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
                    store.send(.closeButtonTapped)
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
        VStack(spacing: .zero) {
            PlayerProgressBar(duration: Double(store.totalDuration / 1000), progress: store.progress, stampTimeList: store.stampTimeList) { stampTime in
                store.send(.seek(stampTime))
            }
            
            Group {
                HStack(spacing: 7) {
                    Button(action: {
                        store.send(.failureTapped)
                    }) {
                        Text("실패로 저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clLogUI.gray600)
                            .foregroundColor(.clLogUI.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        store.send(.successTapped)
                    }) {
                        Text("완등으로 저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clLogUI.white)
                            .foregroundColor(.clLogUI.gray800)
                            .cornerRadius(12)
                    }
                }
                .font(.b1)
                .padding(.horizontal, 16)
            }
            .frame(height: 94)
            .background(
                Color.clLogUI.gray900
                    .edgesIgnoringSafeArea(.bottom)
            )
        }
    }
}
