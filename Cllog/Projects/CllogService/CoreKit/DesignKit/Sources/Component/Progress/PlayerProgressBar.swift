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
    private var splitPositions: [Float]
    
    public init(value: Binding<Float>, splitPositions: [Float] = []) {
        self._value = value
        self.splitPositions = splitPositions
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .foregroundColor(Color.clLogUI.gray50)
                
                Rectangle()
                    .frame(
                        width: min(CGFloat(value) * geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(Color.clLogUI.primary)
                
                ForEach(splitPositions, id: \.self) { position in
                    Rectangle()
                        .frame(width: 1, height: geometry.size.height)
                        .foregroundColor(Color.clLogUI.gray900)
                        .offset(x: CGFloat(position) * geometry.size.width)
                }
            }
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
        }
    }
}
