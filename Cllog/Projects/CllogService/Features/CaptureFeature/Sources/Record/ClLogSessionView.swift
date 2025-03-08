//
//  ClLogSessionView.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct ClLogSessionView: UIViewRepresentable {
    
    @Binding private var isRecording: Bool
    private let fileOutputClousure: (URL, (any Error)?) -> Void
    private let path: URL
    
    public init(
        isRecording: Binding<Bool>,
        fileOutputClousure: @escaping (URL, (any Error)?) -> Void
    ) {
        self._isRecording = isRecording
        self.path = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
        self.fileOutputClousure = fileOutputClousure
    }
    
    public func makeUIView(context: Context) -> ClLogSessionUIView {
        return ClLogSessionUIView(fileOutputclosure: fileOutputClousure)
    }
    
    public func updateUIView(
        _ uiView: ClLogSessionUIView,
        context: Context
    ) {
        if isRecording {
            if !uiView.isRecording {
                uiView.startRecording(to: path)
            }
        } else {
            if uiView.isRecording {
                uiView.stopRecording()
            }
        }
    }
}
