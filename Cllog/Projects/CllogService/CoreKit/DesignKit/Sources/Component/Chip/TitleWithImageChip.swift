//
//  TitleWithImageChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

/// 타이틀 & 옆에 이미지 들어간 칩 (ex. 난이도, 암장..)
public struct TitleWithImageChip: View {
    let title: String
    let imageName: String
    let forgroundColor: Color
    let backgroundColor: Color
    let tapHandler: () -> Void
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.h5)
            Image(imageName, bundle: .module)
                .resizable()
                .frame(width: 21, height: 21)
                .onTapGesture {
                    tapHandler()
                }
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 7))
        .foregroundStyle(forgroundColor)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(backgroundColor)
        )
    }
}

#Preview {
    Group {
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
        
        TitleWithImageChip(
            title: "초록",
            imageName: "icn_close",
            forgroundColor: Color.clLogUI.gray800,
            backgroundColor: Color.clLogUI.primary,
            tapHandler: { print("### 탭") }
        )
        
        TitleWithImageChip(
            title: "더클라임",
            imageName: "icn_close",
            forgroundColor: Color.clLogUI.gray800,
            backgroundColor: Color.clLogUI.primary,
            tapHandler: { print("### 탭") }
        )
    }
}
