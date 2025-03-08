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
    let store: StoreOf<FolderFeature>
    let items = Array(1...20)
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public init(store: StoreOf<FolderFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .padding(.vertical, 18)
            .background(Color.clLogUI.gray800)
    }
}

extension FolderView {
    private func makeBody() -> some View {
        ScrollView {
            VStack (alignment: .leading) {
                Text("나의 클라이밍 기록 32")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.white)
                    .padding(.horizontal, 16)
                
                makeChipView()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, spacing: 20) {
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
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }
    
    private func makeChipView() -> some View {
        let chips = FolderFeature.SelectedChip.allCases
        return ScrollView(.horizontal) {
            HStack {
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
                        TitleWithImageChip(
                            title: "난이도",
                            imageName: isSelectedChip ? "x" : "icon_down",
                            forgroundColor: isSelectedChip ? Color.clLogUI.gray800 :  Color.clLogUI.gray200,
                            backgroundColor: isSelectedChip ? Color.clLogUI.primary : Color.clLogUI.gray600,
                            tapHandler: {
                                store.send(.gradeChipTapped)
                            }
                        )
                        
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
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
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
