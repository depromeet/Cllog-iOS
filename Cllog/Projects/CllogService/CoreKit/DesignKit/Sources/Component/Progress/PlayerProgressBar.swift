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
    private var onSplitPositionsCalculated: (([CGFloat]) -> Void)?
    
    public init(
        value: Binding<Float>,
        splitPositions: [Float] = [],
        onSplitPositionsCalculated: (([CGFloat]) -> Void)? = nil
    ) {
        self._value = value
        self.splitPositions = splitPositions
        self.onSplitPositionsCalculated = onSplitPositionsCalculated
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
                        width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(Color.clLogUI.primary)
                
                ForEach(splitPositions, id: \.self) { position in
                    Rectangle()
                        .frame(width: 1, height: geometry.size.height)
                        .foregroundColor(.black)
                        .offset(x: CGFloat(position) * geometry.size.width)
                }
            }
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            .onAppear {
                let actualPositions = splitPositions.map { CGFloat($0) * geometry.size.width }
                onSplitPositionsCalculated?(actualPositions)
            }
            .onChange(of: geometry.size) { _, newSize in
                let actualPositions = splitPositions.map { CGFloat($0) * newSize.width }
                onSplitPositionsCalculated?(actualPositions)
            }
        }
    }
}
