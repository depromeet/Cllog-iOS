//
//  ReportVideoImageView.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum ChallengeResult {
    case complete
    case fail
    
    var name: String {
        switch self {
        case .complete: "완등"
        case .fail: "실패"
        }
    }
}

public struct ReportVideoImageView: View {
    private let imageName: String
    private let challengeResult: ChallengeResult
    private let deleteButtonHandler: () -> Void
    
    private var borderColor: Color {
        challengeResult == .complete ? Color.clLogUI.complete : Color.clLogUI.fail
    }
    
    public init(imageName: String,
                challengeResult: ChallengeResult,
                deleteButtonHandler: @escaping () -> Void) {
        self.imageName = imageName
        self.challengeResult = challengeResult
        self.deleteButtonHandler = deleteButtonHandler
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            Image(imageName, bundle: .module)
                .resizable()
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 14.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 14.4)
                        .strokeBorder(borderColor, lineWidth: 3)
                )
            
            Button {
                deleteButtonHandler()
            } label: {
                Image("x", bundle: .module)
                    .offset(x: 4, y: -4)
            }
        }
    }
}

#Preview {
    Group {
        ReportVideoImageView(
            imageName: "clogLogo",
            challengeResult: .complete,
            deleteButtonHandler: { print("### 탭") })
        
        ReportVideoImageView(
            imageName: "clogLogo",
            challengeResult: .fail,
            deleteButtonHandler: { print("### 탭") })
    }
}
