//
//  ClimbingCard.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import CalendarDomain
import DesignKit

struct ClimbingCard: View {
    private let climbStory: CalendarStory
    private let onTapped: (Int) -> Void
    
    init(
        climbStory: CalendarStory,
        onTapped: @escaping (Int) -> Void
    ) {
        self.climbStory = climbStory
        self.onTapped = onTapped
    }
    
    var body: some View {
        Button {
            onTapped(climbStory.id)
        } label: {
            makeBody()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.clLogUI.gray700)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

extension ClimbingCard {
    private func makeBody() -> some View {
        HStack(spacing: 12) {
            if let thumbNail = climbStory.thumbnailUrl, let url = URL(string: thumbNail) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    case .failure:
                        ZStack {
                            Color.clLogUI.gray600
                            
                            Image.clLogUI.alert
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.clLogUI.gray500)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    case .empty:
                        ProgressView()
                    default:
                        EmptyView()
                    }
                }
                .frame(width: 50, height: 50)
            } else {
                ZStack {
                    Color.clLogUI.gray600
                    
                    Image.clLogUI.alert
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.gray500)
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 50, height: 50)
            }
            
            
            VStack(alignment: .leading, spacing:4) {
                HStack(spacing:4) {
                    Image.clLogUI.time
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.clLogUI.primary)
                    
                    Text(climbStory.totalDurationMs.msToTimeString)
                        .font(.h4)
                        .foregroundStyle(Color.clLogUI.gray10)
                }
                
                HStack(spacing:6) {
                    Text("문제")
                        .font(.b2)
                        .foregroundStyle(Color.clLogUI.gray400)
                    
                    HStack(spacing:4) {
                        ForEach(climbStory.problems, id: \.self) { problem in
                            Circle()
                                .fill(Color(hex: problem.colorHex))
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ClimbingCard(
        climbStory: CalendarStory(
            id: 0,
            totalDurationMs: 0,
            cragName: "",
            thumbnailUrl: nil,
            problems: []
        )
    ) { _ in
        
    }
}
