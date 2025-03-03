//
//  LevelChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum Level {
    case pink
    case red
    case orange
    case yellow
    case green
    case blue
    case indigo
    case purple
    case brown
    case black
    case gray
    case white
    
    var name: String {
        switch self {
        case .pink: "핑크"
        case .red: "레드"
        case .orange: "주황"
        case .yellow: "노랑"
        case .green: "초록"
        case .blue: "파랑"
        case .indigo: "남색"
        case .purple: "보라"
        case .brown: "갈색"
        case .black: "검정"
        case .gray: "회색"
        case .white: "하양"
        }
    }
    
    // TODO: 색상 에셋 추가 및 아래 컬러 반환색상 변경 필요
    var color: Color {
        switch self {
        case .pink: .white
        case .red: .white
        case .orange: .white
        case .yellow: .white
        case .green: .white
        case .blue: .white
        case .indigo: .white
        case .purple: .white
        case .brown: .white
        case .black: .white
        case .gray: .white
        case .white: .white
        }
    }
}

public struct LevelChip: View {
    private let level: Level
    
    public init(level: Level) {
        self.level = level
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(level.color)
                .frame(width: 10, height: 10)
            
            Text(level.name)
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
    LevelChip(level: .white)
}
