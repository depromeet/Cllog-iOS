//
//  CameraButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct CameraButton: View {
    private var type: CameraButtonType
    private var onTapped: () -> Void
    
    public init(
        type: CameraButtonType,
        onTapped: @escaping () -> Void
    ) {
        self.type = type
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            makeBody()
        }
    }
}

extension CameraButton {
    @ViewBuilder
    private func makeBody() -> some View {
        switch type {
        case .text(let text):
            Text(text)
                .font(.b2)
                .foregroundStyle(Color.clLogUI.white)
                .padding(.vertical, 9.5)
                .padding(.horizontal, 8)
                .background(
                    Capsule()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                )
        case .image(let image):
            ZStack {
                Circle()
                    .fill(Color.clLogUI.gray800.opacity(0.55))
                    .frame(width: 40, height: 40)
                
                image
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clLogUI.white)
            }
        }
    }
}

public enum CameraButtonType {
    case text(String)
    case image(Image)
}

#Preview {
    VStack(spacing: 5) {
        CameraButton(type: .image(.clLogUI.flashOn)) {
            
        }
        
        CameraButton(type: .text("9:16")) {
            
        }
        
        CameraButton(type: .text("00:00:00")) {
            
        }
        
        CameraButton(type: .text("편집")) {
            
        }
    }
}
