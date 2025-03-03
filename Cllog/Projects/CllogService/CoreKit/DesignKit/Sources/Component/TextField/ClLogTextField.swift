//
//  ClLogTextField.swift
//  DesignKit
//
//  Created by Junyoung on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct ClLogTextField: View {
    @Binding private var text: String
    private let placeHolder: String
    @FocusState private var isTextFieldFocused: Bool
    private var configuration: TextFieldConfiguration
    
    private var displayPlaceHolder: String {
        guard text.isEmpty else { return text }
        
        return configuration.state == .error ? "잘못된 입력" : placeHolder
    }
    
    public init(
        placeHolder: String,
        text: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.configuration = TextFieldConfiguration(
            state: .normal
        )
    }
    
    fileprivate init(
        _ placeHolder: String,
        _ text: Binding<String>,
        _ configuration: TextFieldConfiguration
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.configuration = configuration
    }
    
    public var body: some View {
        makeBody()
    }
}

extension ClLogTextField {
    fileprivate func makeBody() -> some View {
        ZStack {
            // TextField
            TextField("", text: $text)
                .padding(.horizontal, 16)
                .tint(configuration.state.foregroundColor)
                .focused($isTextFieldFocused)
            
            // PlaceHolder
            if !isTextFieldFocused {
                Text(displayPlaceHolder)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            }
        }
        .font(.b1)
        .foregroundStyle(configuration.state.foregroundColor)
        .frame(height: 48)
        .background(configuration.state.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay (
            Group {
                if case .error = configuration.state {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            Color.clLogUI.fail,
                            lineWidth: 1
                        )
                }
            }
        )
        .disabled(configuration.state == .disable)
    }
    
    func state(_ state: TextFieldState) -> ClLogTextField {
        var newConfig = self.configuration
        
        newConfig.state = state
        
        return ClLogTextField(self.placeHolder ,$text, newConfig)
    }
}

public enum TextFieldState {
    case normal
    case disable
    case error
    
    var backgroundColor: Color {
        switch self {
        case .normal, .disable:
            return .clLogUI.gray900
        case .error:
            return .clLogUI.textFail
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .normal:
            return .clLogUI.gray50
        case .disable:
            return .clLogUI.gray600
        case .error:
            return .clLogUI.fail
        }
    }
}

public struct TextFieldConfiguration {
    var state: TextFieldState
}

public struct ContainerClLogTextField: View {
    @State private var textNormal: String
    @State private var textDisable: String
    @State private var textError: String
    
    init(
        textNormal: String,
        textDisable: String,
        textError: String
    ) {
        self.textNormal = textNormal
        self.textDisable = textDisable
        self.textError = textError
    }
    
    public var body: some View {
        GroupBox(label: Text("Normal")) {
            ClLogTextField(
                placeHolder: "암장을 입력해 주세요",
                text: $textNormal
            )
            .state(.normal)
        }
        
        GroupBox(label: Text("Error")) {
            ClLogTextField(
                placeHolder: "암장을 입력해 주세요",
                text: $textDisable
            )
            .state(.error)
        }
        
        GroupBox(label: Text("Disable")) {
            ClLogTextField(
                placeHolder: "암장을 입력해 주세요",
                text: $textError
            )
            .state(.disable)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ContainerClLogTextField(
            textNormal: "",
            textDisable: "",
            textError: ""
        )
    }
}
