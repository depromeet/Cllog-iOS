//
//  CompleteOrFailChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct CompleteOrFailChip: View {
    let challengeResult: ChallengeResult
    let isActive: Bool
    
    private var color: Color {
        if isActive {
            challengeResult == .complete ? Color.clLogUI.complete : Color.clLogUI.fail
        } else {
            Color.clLogUI.gray600
        }
    }
    
    public var body: some View {
        Text(challengeResult.name)
            .font(.h5)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundStyle(isActive ? Color.clLogUI.white : Color.clLogUI.gray200)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(color)
            )
    }
}

#Preview {
    Group {
        CompleteOrFailChip(
            challengeResult: .complete,
            isActive: true
        )
        CompleteOrFailChip(
            challengeResult: .fail,
            isActive: true
        )
        CompleteOrFailChip(
            challengeResult: .complete,
            isActive: false
        )
        CompleteOrFailChip(
            challengeResult: .fail,
            isActive: false
        )
    }
}
