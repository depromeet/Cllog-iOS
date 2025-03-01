//
//  StampButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum StampType {
    case `default`
    case lined
}

public struct StampButton: View {
    private let type: StampType
    private var onTapped: () -> Void
    
    fileprivate let frameSize: CGFloat = 40
    fileprivate let padding: CGFloat = 10
    fileprivate let cornerRadius: CGFloat = 20
    fileprivate let lineWidth: CGFloat = 3
    
    public init(
        type: StampType = .default,
        onTapped: @escaping () -> Void
    ) {
        self.type = type
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            Image.clLogUI.stamp
                .resizable()
                .frame(
                    width: frameSize,
                    height: frameSize
                )
                .foregroundStyle(Color.clLogUI.primary)
                .padding(padding)
                .background(Color.clLogUI.green800)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    Group {
                        if case .lined = type {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .strokeBorder(
                                    Color.clLogUI.primary,
                                    lineWidth: lineWidth
                                )
                        }
                    }
                )
        }
    }
}

#Preview {
    HStack {
        GroupBox(label: Text("Default Stamp")) {
            StampButton() {
                
            }
        }
        
        GroupBox(label: Text("Lined Stamp")) {
            StampButton(type: .lined) {
                
            }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clLogUI.gray700)
}
