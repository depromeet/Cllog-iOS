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
            .padding(.horizontal, 16)
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
                
                HStack(spacing: 8) {
                    CompleteOrFailChip(challengeResult: .complete, isActive: false)
                    CompleteOrFailChip(challengeResult: .fail, isActive: false)
                    TitleWithImageChip(
                        title: "난이도",
                        imageName: "icon_down",
                        forgroundColor: Color.clLogUI.gray200,
                        backgroundColor: Color.clLogUI.gray600,
                        tapHandler: { print("### 탭") }
                    )
                    TitleWithImageChip(
                        title: "암장",
                        imageName: "icon_down",
                        forgroundColor: Color.clLogUI.gray200,
                        backgroundColor: Color.clLogUI.gray600,
                        tapHandler: { print("### 탭") }
                    )
                }
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
        }
        .scrollIndicators(.hidden)
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
