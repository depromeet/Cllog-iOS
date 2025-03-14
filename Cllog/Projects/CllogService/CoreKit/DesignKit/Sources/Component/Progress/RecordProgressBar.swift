//
//  RecordProgressBar.swift
//  DesignKit
//
//  Created by saeng lin on 3/13/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct RecordProgressBar: View {
    
    private var progress: CGFloat
    
    public init(progress: CGFloat) {
        self.progress = progress
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 8)

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.green)
                    // progress 비율에 따라 너비 결정
                    .frame(width: geometry.size.width * min(progress, 1.0),
                           height: 8)
            }
        }
        .frame(height: 8)
    }
}


