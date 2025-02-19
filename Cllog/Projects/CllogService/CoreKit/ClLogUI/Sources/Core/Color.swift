//
//  Color.swift
//  ClLogUI
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

extension ClLogUI where Base == UIColor {
    
    public static var background: UIColor { asset(#function) }
}

extension ClLogUI where Base == Color {
     
    public static var background: Color { Color(uiColor: .clLogUI.background) }
}

extension ClLogUI where Base == UIColor {
    
    private static func asset(_ name: String) -> UIColor {
        let colorName = "clLogUI_" + name
        guard let color = UIColor(named: colorName, in: .clLogUIBundle, compatibleWith: nil) else {
            assertionFailure("can't find color asset: \(colorName)")
            return UIColor.clear
        }
        return color
    }
}
