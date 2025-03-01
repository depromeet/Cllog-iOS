//
//  CameraButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct CameraButton: View {
    private var configuration: CameraButtonConfiguration
    private var onTapped: () -> Void
    
    public init(
        _ onTapped: @escaping () -> Void
    ) {
        self.onTapped = onTapped
        self.configuration = CameraButtonConfiguration(
            type: .time("")
        )
    }
    fileprivate init(
        _ configuration: CameraButtonConfiguration,
        onTapped: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            configuration.type.element
        }
    }
}

public struct CameraButtonConfiguration {
    var type: CameraButtonType
}

public enum CameraButtonType {
    case flashOn
    case flashOff
    case ratio
    case angle
    case time(String)
    case close
    case edit
    case end
    
    @ViewBuilder
    var element: some View {
        switch self {
        case .flashOn:
            Image.clLogUI.flashOn
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        case .flashOff:
            Image.clLogUI.flashOff
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        case .ratio:
            Text("9:16")
                .font(.b2)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        case .angle:
            Text("1x")
                .font(.b2)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        case .time(let text):
            Text(text)
                .font(.b2)
                .foregroundStyle(Color.clLogUI.white)
                .padding(.vertical, 9.5)
                .padding(.horizontal, 8)
                .background(Color.clLogUI.gray800.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 99))
        case .close:
            Image.clLogUI.close
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        case .edit:
            Text("편집")
                .font(.b2)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        case .end:
            Text("종료")
                .font(.b2)
                .foregroundStyle(Color.clLogUI.white)
                .background(
                    Circle()
                        .fill(Color.clLogUI.gray800.opacity(0.55))
                        .frame(width: 40, height: 40)
                )
                .frame(width: 40, height: 40)
        }
    }
}

// MARK: - Button Extension
public extension CameraButton {
    func type(_ type: CameraButtonType) -> CameraButton {
        
        var newConfig = self.configuration
        
        newConfig.type = type
            
        return CameraButton(newConfig, onTapped: self.onTapped)
    }
}

#Preview {
    VStack(spacing: 5) {
        CameraButton() {
            
        }
        .type(.flashOn)
        
        CameraButton() {
            
        }
        .type(.flashOff)
        
        CameraButton() {
            
        }
        .type(.ratio)
        
        CameraButton() {
            
        }
        .type(.angle)
        
        CameraButton() {
            
        }
        .type(.time("00:00:00"))
        
        CameraButton() {
            
        }
        .type(.close)
        
        CameraButton() {
            
        }
        .type(.edit)
        
        CameraButton() {
            
        }
        .type(.end)
    }
}
