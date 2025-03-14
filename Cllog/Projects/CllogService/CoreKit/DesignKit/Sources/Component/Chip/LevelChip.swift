//
//  LevelChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct LevelChip: View {
    let name: String
    let color: Color
    
    public init(
        name: String,
        color: Color
    ) {
        self.name = name
        self.color = color
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(name)
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray200)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.clLogUI.gray700)
        )
    }
}

#Preview {
    LevelChip(name: "하양", color: .white)
}
