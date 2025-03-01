//
//  RecodingButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct RecodingButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var isRecoding: Bool
    private let onTapped: () -> Void
    
    public init(
        isRecoding: Binding<Bool>,
        onTapped: @escaping () -> Void
    ) {
        self._isRecoding = isRecoding
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            if isRecoding {
                Image.clLogUI.recordingButton
                    .resizable()
                    .frame(width: 70, height: 70)
                    .animation(.easeInOut(duration: 0.5), value: isRecoding)
            } else {
                Image.clLogUI.recodeButton
                    .resizable()
                    .foregroundStyle(
                        isEnabled ?
                        Color.clLogUI.white :
                        Color.clLogUI.gray400
                    )
                    .frame(width: 70, height: 70)
                    .animation(.easeInOut(duration: 0.5), value: isRecoding)
            }
        }
    }
}

// MARK: - Preview
private struct RecodingTestView: View {
    @State var isRecoding: Bool
    
    var body: some View {
        RecodingButton(isRecoding: $isRecoding) {
            isRecoding.toggle()
        }
        .disabled(false)
    }
}

#Preview {
    ZStack {
        RecodingTestView(isRecoding: false)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clLogUI.gray700)
}
