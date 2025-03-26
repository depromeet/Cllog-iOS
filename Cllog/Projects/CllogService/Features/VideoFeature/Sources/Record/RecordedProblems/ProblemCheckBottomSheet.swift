//
//  ProblemCheckBottomSheet.swift
//  VideoFeature
//
//  Created by seunghwan Lee on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import DesignKit

struct ProblemView: View {
    @State private var isOpened: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 16, height: 16)
                
                Text("문제 1")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.white)
                
                Button {
                    isOpened.toggle()
                } label: {
                    isOpened ? Image.clLogUI.dropdownUp : Image.clLogUI.dropdownDown
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text("실패 1")
                    Color.clLogUI.gray700
                        .frame(width: 1, height: 14)
                    Text("완등 3")
                }
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray200)
            }
            .padding(.horizontal, 16)
            
            if isOpened {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 12) {
                        ForEach(0..<10, id: \.self) { idx in
                            ReportVideoImageView(
                                imageName: "clogLogo",
                                challengeResult: idx == 0 ? .fail : .complete,
                                deleteButtonHandler: { print("### 탭") })
                        }
                    }
                    .frame(height: 84)
                    .padding(.top, 4)
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)
                .padding(.top, 8)
            }
        }
    }
}

struct ProblemCheckBottomSheet: View {
    var divider: some View {
        Color.clLogUI.gray700
            .frame(height: 1)
            .padding(.vertical, 20)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { idx in
                ProblemView()
                
                if idx != 2 {
                    divider
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    Color.white
        .bottomSheet(isPresented: .constant(true), height: 355) {
            ProblemCheckBottomSheet()
        }
}
