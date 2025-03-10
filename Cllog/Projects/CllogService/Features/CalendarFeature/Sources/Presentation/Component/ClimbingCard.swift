//
//  ClimbingCard.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import DesignKit

struct ClimbingCard: View {
    private let onTapped: () -> Void
    
    init(onTapped: @escaping () -> Void) {
        self.onTapped = onTapped
    }
    
    var body: some View {
        Button {
            onTapped()
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
            
            AsyncImage(url: URL(string: "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    Color.clLogUI.gray900
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
            
            VStack(alignment: .leading, spacing:4) {
                HStack(spacing:4) {
                    Image.clLogUI.time
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.clLogUI.primary)
                    
                    Text("00:00:00")
                        .font(.h4)
                        .foregroundStyle(Color.clLogUI.gray10)
                }
                
                HStack(spacing:4) {
                    Text("문제")
                        .font(.b2)
                        .foregroundStyle(Color.clLogUI.gray400)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ClimbingCard() {
        
    }
}
