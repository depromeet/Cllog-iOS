//
//  CheckBoxButton.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct CheckBoxButton: View {
    @Binding private var isActive: Bool
    private let text: String
    
    public init(isActive: Binding<Bool>, text: String) {
        self._isActive = isActive
        self.text = text
    }
    
    public var body: some View {
        Button {
            isActive.toggle()
        } label: {
            HStack(spacing: 6) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(isActive ? Color.clLogUI.primary : Color.clLogUI.gray600)
                    
                    if isActive {
                        ClLogUI.check
                            .foregroundStyle(Color.clLogUI.gray900)
                    }
                }
                
                Text(text)
                    .foregroundStyle(
                        isActive
                        ? Color.clLogUI.gray50
                        : Color.clLogUI.gray100
                    )
                    .font(.h4)
            }
        }
    }
}

struct CheckBoxButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            CheckBoxButton(isActive: .constant(true), text: "선택됨")
            CheckBoxButton(isActive: .constant(false), text: "선택 안됨")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
