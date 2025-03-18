//
//  FolderView.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import Core
import DesignKit
import ComposableArchitecture

public struct FolderView: ViewProtocol {
    @Bindable var store: StoreOf<FolderFeature>
    let items = Array(1...20)
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(store: StoreOf<FolderFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBodyView()
            .padding(.vertical, 18)
            .background(Color.clLogUI.gray800)
            .onAppear {
                store.send(.onAppear)
            }
            .bottomSheet(isPresented: $store.showSelectGradeBottomSheet) {
                showSelectGradeBottomSheet()
            }
            .bottomSheet(isPresented: $store.showSelectCragBottomSheet) {
                showSelectCragBottomSheet()
            }
    }
}

extension FolderView {
    private func makeBodyView() -> some View {
        ZStack {
            switch store.viewState {
            case .loading:
                makeLoadingView()
                
            case .empty:
                makeEmptyView()
                
            case .content:
                makeContentView()
            }
        }
    }
    
    private func makeLoadingView() -> some View {
        ZStack {
            Color.clLogUI.gray800
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: ClLogUI.gray500))
                .scaleEffect(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    }
    
    private func makeEmptyView() -> some View {
        VStack(spacing: 20) {
            ClLogUI.videoNone
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundStyle(Color.clLogUI.gray500)
            
            Text("아직 기록이 없어요.")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.gray500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func makeContentView() -> some View {
        ScrollView {
            VStack (alignment: .leading) {
                makeTitleView()
                    .padding(.horizontal, 16)
                
                ScrollView(.horizontal) {
                    makeChipView()
                }
                .scrollIndicators(.hidden)
                .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            makeThumbnailView()
                .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }
    
    private func makeTitleView() -> some View {
        HStack(spacing: 7) {
            Text("나의 클라이밍 기록")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            Text("\(store.attempts.count)")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.gray300)
        }
    }
    
    private func makeChipView() -> some View {
        HStack {
            Spacer()
                .frame(width: 16)
            
            ForEach(store.chips, id: \.self) { chip in
                
                let isSelectedChip = switch chip {
                case .complete: store.attemptFilter.attemptResult == .complete
                case .fail: store.attemptFilter.attemptResult == .fail
                case .grade: store.attemptFilter.grade != nil
                case .crag: store.attemptFilter.crag != nil
                }
                
                switch chip {
                case .complete:
                    CompleteOrFailChip(
                        challengeResult: .complete,
                        isActive: isSelectedChip
                    ).onTapGesture {
                        store.send(.completeChipTapped)
                    }
                case .fail:
                    CompleteOrFailChip(
                        challengeResult: .fail,
                        isActive: isSelectedChip
                    ).onTapGesture {
                        store.send(.failChipTapped)
                    }
                case .grade:
                    TitleWithImageChip(
                        title: isSelectedChip ? store.attemptFilter.grade?.name ?? "" : "난이도",
                        imageName: isSelectedChip ? "close" : "icon_down",
                        forgroundColor: isSelectedChip ? Color.clLogUI.gray800 : Color.clLogUI.gray200,
                        backgroundColor: isSelectedChip ? Color.clLogUI.primary : Color.clLogUI.gray600,
                        tapHandler: {
                            store.send(.gradeChipTapped)
                        }
                    )
                case .crag:
                    TitleWithImageChip(
                        title: isSelectedChip ? store.attemptFilter.crag?.name ?? "" : "암장",
                        imageName: isSelectedChip ? "close" : "icon_down",
                        forgroundColor: isSelectedChip ? Color.clLogUI.gray800 : Color.clLogUI.gray200,
                        backgroundColor: isSelectedChip ? Color.clLogUI.primary : Color.clLogUI.gray600,
                        tapHandler: {
                            store.send(.cragChipTapped)
                        }
                    )
                }
            }
        }
    }
    
    func makeThumbnailView() -> some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(store.attempts, id: \.self) { attempt in
                ThumbnailView(
                    imageURLString: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
                    thumbnailType: .default(
                        cragName: attempt.crag?.name ?? "",
                        date: attempt.date
                    ),
                    challengeResult: attempt.result == .complete ? .complete : .fail,
                    levelName: attempt.grade?.name ?? "하양",
                    levelColor: Color(hex: attempt.grade?.hexCode ?? "0x00000"),
                    time: attempt.recordedTime
                )
            }
        }
    }
    
    private func showSelectGradeBottomSheet() -> some View {
        let rows: [GridItem] = [.init(.adaptive(minimum: 60), spacing: 6)]
        return VStack(alignment: .leading, spacing: 16) {
            Text("난이도")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            Divider()
                .foregroundStyle(Color.clLogUI.gray600)
            
            LazyVGrid(columns: rows) {
                ForEach(store.grades, id: \.self) { grade in
                    LevelChip(
                        name: grade.name,
                        color: Color(hex: grade.hexCode)
                    )
                    .onTapGesture {
                        store.send(.didSelectGrade(grade))
                    }
                }
            }
        }
    }
    
    private func showSelectCragBottomSheet() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("암장명")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            ClLogTextInput(
                placeHolder: "암장을 입력해주세요",
                text: $store.searchCragName
            )
            
            ForEach(store.crags.filter { crag in
                if store.searchCragName.isEmpty {
                    return true
                }
                
                return crag.name.matchesPattern(store.searchCragName)
            }, id: \.self) { crag in
                TwoLineRow(
                    title: crag.name,
                    subtitle: crag.address
                )
                .onTapGesture {
                    store.send(.didSelectCrag(crag))
                }
            }
        }
    }
}

#Preview {
    FolderView(
        store: .init(
            initialState: FolderFeature.State(),
            reducer: {
                FolderFeature()
            }
        )
    )
}
