//
//  ProblemCheckCompleteBottomSheet.swift
//  VideoFeature
//
//  Created by seunghwan Lee on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import DesignKit

struct ProblemCheckCompleteBottomSheet: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("총 운동 시간")
                    .frame(height: 21)
                    .font(.h5)
                    .foregroundStyle(Color.clLogUI.gray400)
                Text("00:32:10")
                    .frame(height: 36)
                    .font(.h1)
                    .foregroundStyle(Color.clLogUI.gray10)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Color.clLogUI.gray900
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            
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
            .padding(.bottom, 24)
            
            GeneralButton("종료하기") {
                print("### 종료하기 탭탭")
            }
            .style(.white)
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    Color.white
        .bottomSheet(isPresented: .constant(true), height: 355) {
            ProblemCheckCompleteBottomSheet()
        }
}
