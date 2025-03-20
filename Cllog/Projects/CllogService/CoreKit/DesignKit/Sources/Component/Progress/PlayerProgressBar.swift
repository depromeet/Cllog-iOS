//
//  PlayerProgressBar.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI


public struct ProgressSplitItem: Hashable {
    let id: Int
    let position: Float
    
    public init(id: Int, position: Float) {
        self.id = id
        self.position = position
    }
}

public struct PlayerProgressBar: View {
    @Binding private var value: Float
    private var splitItems: [ProgressSplitItem]
    private var onSplitItemTapped: ((Int) -> Void)?
    
    public init(
        value: Binding<Float>,
        splitItems: [ProgressSplitItem] = [],
        onSplitItemTapped: ((Int) -> Void)? = nil
    ) {
        self._value = value
        self.splitItems = splitItems
        self.onSplitItemTapped = onSplitItemTapped
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            // 스탬프 레이어
            ZStack(alignment: .bottomLeading) {
                ForEach(splitItems, id: \.self) { item in
                    ClLogUI.stamp
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.clLogUI.primary)
                        .offset(x: CGFloat(item.position * 100) - 15)  // 이미지 중앙 정렬을 위한 width/2
                        .onTapGesture {
                            onSplitItemTapped?(item.id)
                        }
                }
            }
            
            // 프로그레스 바 레이어
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 배경 바
                    Rectangle()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                        .foregroundColor(Color.clLogUI.gray50)
                    
                    // 진행 바
                    Rectangle()
                        .frame(
                            width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width),
                            height: geometry.size.height
                        )
                        .foregroundColor(Color.clLogUI.primary)
                    
                    // 분할 위치 표시
                    ForEach(splitItems, id: \.self) { item in
                        Rectangle()
                            .frame(width: 1, height: geometry.size.height)
                            .foregroundColor(.black)
                            .offset(x: CGFloat(item.position) * geometry.size.width)
                    }
                }
                .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            }
            .frame(height: 10)
        }
    }
}
