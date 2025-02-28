//
//  GeneralButton.swift
//  DesignKit
//
//  Created by Junyoung on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// MARK: - Button View
public struct GeneralButton: View {
    private var configuration: GeneralButtonConfiguration
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var onTapped: () -> Void
    
    public init(
        _ text: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.onTapped = onTapped
        self.configuration = GeneralButtonConfiguration(
            style: .large,
            text: text
        )
    }
    fileprivate init(
        _ configuration: GeneralButtonConfiguration,
        onTapped: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button(action: {
            onTapped()
        }, label: {
            Text(configuration.text)
                .font(.b1)
                .padding(.vertical, 15)
                .padding(.horizontal, configuration.style.horizontalPadding)
                .frame(
                    maxWidth: configuration.style.horizontalPadding == nil ?
                        .infinity :
                        nil
                )
                .foregroundStyle(
                    isEnabled ?
                    configuration.style.foregroundColor :
                    Color.clLogUI.gray400
                )
                .background(
                    isEnabled ?
                    configuration.style.backgroundColor :
                    Color.clLogUI.gray700
                )
                .cornerRadius(12)
        })
    }
}

// MARK: - Button Configuration
public struct GeneralButtonConfiguration {
    var style: GeneralButtonStyle
    var text: String
}

// MARK: Button Style
public enum GeneralButtonStyle {
    case large
    case medium
    case small
    
    var foregroundColor: Color {
        switch self {
        case .large:
            return .clLogUI.gray800
        case .medium, .small:
            return .clLogUI.white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .large:
            return .clLogUI.white
        case .medium, .small:
            return .clLogUI.gray600
        }
    }
    
    var horizontalPadding: CGFloat? {
        switch self {
        case .large:
            return nil
        case .medium:
            return 47.0
        case .small:
            return 30.0
        }
    }
}

// MARK: - Button Extension
public extension GeneralButton {
    func style(_ style: GeneralButtonStyle) -> GeneralButton {
        
        var newConfig = self.configuration
        
        newConfig.style = style
            
        return GeneralButton(newConfig, onTapped: self.onTapped)
    }
}

// MARK: - Preview
#Preview {
    
    VStack {
        Text("Large")
            .foregroundStyle(Color.clLogUI.white)
            .font(.h1)
        HStack {
            VStack {
                Text("Enable")
                    .foregroundStyle(Color.clLogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.large)
            }
            
            VStack {
                Text("Disable")
                    .foregroundStyle(Color.clLogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.large)
                .disabled(true)
            }
        }
        .padding(.bottom, 10)
        
        Text("Medium")
            .foregroundStyle(Color.clLogUI.white)
            .font(.h1)
        HStack {
            VStack {
                Text("Enable")
                    .foregroundStyle(Color.clLogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.medium)
            }
            
            VStack {
                Text("Disable")
                    .foregroundStyle(Color.clLogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.medium)
                .disabled(true)
            }
        }
        .padding(.bottom, 10)
        
        Text("Small")
            .foregroundStyle(Color.clLogUI.white)
            .font(.h1)
        HStack {
            VStack {
                Text("Enable")
                    .foregroundStyle(Color.clLogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.small)
            }
            
            VStack {
                Text("Disable")
                    .foregroundStyle(Color.clLogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.small)
                .disabled(true)
            }
        }
    }
    .padding(16)
    .background(Color.clLogUI.gray800)
}

