//
//  PlayerProgressBar.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// FIXME: 임시 스탬프 모델
public struct TempStamp: Identifiable {
    public let id: Int
    public let position: CGFloat
    
    public init(id: Int, position: CGFloat) {
        self.id = id
        self.position = position
    }
}

public struct PlayerProgressBar: View {
    private enum Constnats {
        static let stampHalfWidth: CGFloat = 9
        static let stampYOffset: CGFloat = -3
    }
    
    private let progress: CGFloat
    private let stamps: [TempStamp]
    private let onStampTapped: ((Int) -> Void)?
    
    public init(
        progress: CGFloat,
        stamps: [TempStamp] = [],
        onStampTapped: ((Int) -> Void)? = nil
    ) {
        self.progress = progress.isNaN ? 0 : progress
        self.stamps = stamps
        self.onStampTapped = onStampTapped
    }
    
    private var stampArea: some View {
        Color.clear
            .frame(height: 15)
            .overlay {
                ForEach(stamps) {
                    Image.clLogUI.stamp
                        .foregroundStyle(Color.clLogUI.primary)
                        .position(x: $0.position + Constnats.stampHalfWidth, y: Constnats.stampYOffset)
                }
            }
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            stampArea
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Color.clLogUI.primary
                        .frame(width: geometry.size.width * min(progress, 1.0))
                    
                    Color.clLogUI.gray50
                        .frame(maxWidth: .infinity)
                }
                .overlay {
                    ForEach(stamps) { stamp in
                        Rectangle()
                            .fill(Color.clLogUI.gray900)
                            .frame(width: 1)
                            .position(x: stamp.position + Constnats.stampHalfWidth, y: geometry.size.height / 2)
                            .onTapGesture {
                                onStampTapped?(stamp.id)
                            }
                    }
                }
            }
            .frame(height: 5)
        }
    }
}
