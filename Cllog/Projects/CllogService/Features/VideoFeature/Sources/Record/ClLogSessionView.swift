//
//  ClLogSessionView.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct ClLogSessionView: UIViewRepresentable {
    
    public typealias UIViewType = ClLogSessionUIView
    
    public func makeUIView(context: Context) -> ClLogSessionUIView {
        return ClLogSessionUIView(
            frame: UIScreen.main.bounds
        )
    }
    
    public func updateUIView(_ uiView: ClLogSessionUIView, context: Context) {
        
    }
    
}
