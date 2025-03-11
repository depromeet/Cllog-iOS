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
        return makeBodyView()
            .padding(.vertical, 18)
            .background(Color.clLogUI.gray800)
            .bottomSheet(isPresented: $store.showSelectGradeBottomSheet) {
                showSelectGradeBottomSheet()
            }
            .bottomSheet(isPresented: $store.showSelectCragBottomSheet) {
                Text("BYE")
            }
    }
}

extension FolderView {
    private func makeBodyView() -> some View {
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
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private func makeTitleView() -> some View {
        HStack(spacing: 7) {
            Text("나의 클라이밍 기록")
                .font(.h3)
                .foregroundStyle(Color.clLogUI.white)
            
            if store.countOfFilteredStories != 0 {
                Text("\(store.countOfFilteredStories)")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.gray300)
            }
        }
    }
    
    private func makeChipView() -> some View {
        let chips = FolderFeature.SelectedChip.allCases
        return HStack {
            Spacer()
                .frame(width: 16)
            
            ForEach(chips, id: \.self) { chip in
                let isSelectedChip = store.selectedChip.contains(chip)
                
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
                    if let selectedGrade = store.selectedGrade {
                        TitleWithImageChip(
                            title: selectedGrade.name,
                            imageName: "close",
                            forgroundColor: Color.clLogUI.gray800,
                            backgroundColor: Color.clLogUI.primary,
                            tapHandler: {
                                store.send(.gradeChipTapped)
                            }
                        )
                    } else {
                        TitleWithImageChip(
                            title: "난이도",
                            imageName: "icon_down",
                            forgroundColor: Color.clLogUI.gray200,
                            backgroundColor: Color.clLogUI.gray600,
                            tapHandler: {
                                store.send(.gradeChipTapped)
                            }
                        )
                    }

                case .crag:
                    TitleWithImageChip(
                        title: isSelectedChip ? store.selectedCragName : "암장",
                        imageName: isSelectedChip ? "x" : "icon_down",
                        forgroundColor: isSelectedChip ? Color.clLogUI.gray800 :  Color.clLogUI.gray200,
                        backgroundColor: isSelectedChip ? Color.clLogUI.primary : Color.clLogUI.gray600,
                        tapHandler: {
                            store.send(.cragChipTapped(cragName: "엄청나게 긴긴긴긴긴 암장 이름입 니 다~!"))
                        }
                    )
                }
            }
        }
    }
    
    func makeThumbnailView() -> some View {
        let items = Array(1...store.countOfFilteredStories)
        
        return LazyVGrid(columns: columns, spacing: 20) {
            ForEach(items, id: \.self) { item in
                ThumbnailView(
                    imageURLString: "https://www.dictionary.com/e/wp-content/uploads/2018/05/lhtm.jpg",
                    thumbnailType: .default(
                        cragName: "클라이밍파크 강남점",
                        date: "25.02.08 FRI"
                    ),
                    challengeResult: .complete,
                    level: .blue,
                    time: "00:00:00"
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
                ForEach(store.grades, id: \.hexCode) { grade in
                    LevelChip(level: .blue)
                        .onTapGesture {
                            store.send(.didSelectGrade(grade))
                        }
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
