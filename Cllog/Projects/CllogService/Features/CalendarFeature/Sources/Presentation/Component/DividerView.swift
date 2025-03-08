//
//  DividerView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

enum DividerType {
    case horizontal
    case vertical
}

struct DividerView: View {
    private let type: DividerType
    
    init(_ type: DividerType) {
        self.type = type
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.clLogUI.gray800)
                .frame(
                    width: type == .vertical ? 1 : nil,
                    height: type == .horizontal ? 1 : nil
                )
        }
        .frame(
            width: type == .vertical ? 35.5 : nil,
            height: type == .horizontal ? 17 : nil
        )
    }
}
