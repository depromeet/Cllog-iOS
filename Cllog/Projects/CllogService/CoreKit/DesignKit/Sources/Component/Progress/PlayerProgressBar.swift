//
//  PlayerProgressBar.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct PlayerProgressBar: View {
    @Binding private var value: Float
    
    public init(value: Binding<Float>) {
        self._value = value
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .foregroundColor(Color.clLogUI.gray50)
                
                Rectangle()
                    .frame(
                        width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(Color.clLogUI.primary)
            }
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
    }
}
