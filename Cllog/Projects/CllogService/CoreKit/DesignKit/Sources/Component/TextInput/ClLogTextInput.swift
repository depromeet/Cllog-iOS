//
//  ClLogTextField.swift
//  DesignKit
//
//  Created by Junyoung on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct ClLogTextInput: View {
    @Binding private var text: String
    private let placeHolder: String
    @FocusState private var isTextFieldFocused: Bool
    private var configuration: TextInputConfiguration
    
    public init(
        placeHolder: String,
        text: Binding<String>
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.configuration = TextInputConfiguration(
            state: .normal,
            type: .filed,
            background: .gray900
        )
    }
    
    fileprivate init(
        _ placeHolder: String,
        _ text: Binding<String>,
        _ configuration: TextInputConfiguration
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self.configuration = configuration
    }
    
    public var body: some View {
        makeBody()
    }
}

extension ClLogTextInput {
    fileprivate func makeBody() -> some View {
        ZStack(
            alignment: configuration.type == .editor ?
                .topLeading : .center
        ) {
            switch configuration.type {
            case .filed:
                // TextField
                TextField("", text: $text)
                    .padding(.horizontal, 16)
                    .tint(configuration.state.foregroundColor)
                    .focused($isTextFieldFocused)
            case .editor:
                // TextEditor
                TextEditor(text: $text)
                    .scrollContentBackground(.hidden)
                    .padding(16)
                    .tint(configuration.state.foregroundColor)
                    .focused($isTextFieldFocused)
            }
            
            // PlaceHolder
            if !isTextFieldFocused && text.isEmpty {
                Text(placeHolder)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, configuration.type == .editor ? 16 : 0)
            }
        }
        .font(.b1)
        .foregroundStyle(configuration.state.foregroundColor)
        .frame(height: configuration.type == .editor ? 128 : 48)
        .background(configuration.background.color)
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
    
    public func state(_ state: TextInputState) -> ClLogTextInput {
        var newConfig = self.configuration
        
        newConfig.state = state
        
        return ClLogTextInput(self.placeHolder ,$text, newConfig)
    }
    
    public func type(_ type: TextInputType) -> ClLogTextInput {
        var newConfig = self.configuration
        
        newConfig.type = type
        
        return ClLogTextInput(self.placeHolder ,$text, newConfig)
    }
    
    public func background(_ type: TextInputBackground) -> ClLogTextInput {
        var newConfig = self.configuration
        
        newConfig.background = type
        
        return ClLogTextInput(self.placeHolder ,$text, newConfig)
    }
}

// MARK: - Preview
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
            ClLogTextInput(
                placeHolder: "암장을 입력해 주세요",
                text: $textNormal
            )
            .state(.normal)
        }
        
        GroupBox(label: Text("Edior Error")) {
            ClLogTextInput(
                placeHolder: "암장을 입력해 주세요",
                text: $textDisable
            )
            .type(.editor)
            .state(.error)
        }
        
        GroupBox(label: Text("Disable")) {
            ClLogTextInput(
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
