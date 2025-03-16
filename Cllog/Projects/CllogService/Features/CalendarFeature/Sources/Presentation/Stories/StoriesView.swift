//
//  StoriesView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

struct StoriesView: View {
    private let calendarColumns = Array(repeating: GridItem(.flexible(), spacing: 18), count: 2)
    private let store: StoreOf<StoriesFeature>
    
    init(store: StoreOf<StoriesFeature>) {
        self.store = store
    }
    
    var body: some View {
        makeBody()
    }
}

extension StoriesView {
    private func makeBody() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(.red)
                    .frame(width: 16, height: 16)
                
                Text("문제1")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.white)
            }
            
            LazyVGrid(columns: calendarColumns, spacing: 11) {
                ForEach(0..<5, id: \.self) { _ in
                    ThumbnailView(
                        imageURLString: "",
                        thumbnailType: .calendar,
                        challengeResult: .complete,
                        levelName: "",
                        levelColor: .black,
                        time: "00:00:00"
                    )
                }
            }
        }
    }
}

#Preview {
    StoriesView(
        store: .init(
            initialState: StoriesFeature.State(),
            reducer: {
                StoriesFeature()
            }
        )
    )
}
