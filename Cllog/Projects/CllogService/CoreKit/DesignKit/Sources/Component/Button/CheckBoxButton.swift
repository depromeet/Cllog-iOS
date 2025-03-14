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
    private let title: String
    
    public init(title: String, isActive: Binding<Bool>) {
        self.title = title
        self._isActive = isActive
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
                
                Text(title)
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
            CheckBoxButton(title: "선택됨", isActive: .constant(true))
            CheckBoxButton(title: "선택 안됨", isActive: .constant(false))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
