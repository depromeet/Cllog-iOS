//
//  Color+Extension.swift
//  DesignKit
//
//  Created by soi on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
