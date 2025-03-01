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
    
    public static var white: UIColor { asset(#function) }
    public static var gray10: UIColor { asset(#function) }
    public static var gray50: UIColor { asset(#function) }
    public static var gray100: UIColor { asset(#function) }
    public static var gray200: UIColor { asset(#function) }
    public static var gray300: UIColor { asset(#function) }
    public static var gray400: UIColor { asset(#function) }
    public static var gray500: UIColor { asset(#function) }
    public static var gray600: UIColor { asset(#function) }
    public static var gray700: UIColor { asset(#function) }
    public static var gray800: UIColor { asset(#function) }
    public static var gray900: UIColor { asset(#function) }
    public static var primary: UIColor { asset(#function) }
    public static var green100: UIColor { asset(#function) }
    public static var green200: UIColor { asset(#function) }
    public static var green300: UIColor { asset(#function) }
    public static var green400: UIColor { asset(#function) }
    public static var green500: UIColor { asset(#function) }
    public static var green600: UIColor { asset(#function) }
    public static var green700: UIColor { asset(#function) }
    public static var green800: UIColor { asset(#function) }
    public static var green900: UIColor { asset(#function) }
    public static var dim: UIColor { asset(#function) }
    
}

extension ClLogUI where Base == Color {
     
    public static var white: Color { asset(#function) }
    public static var gray10: Color { asset(#function) }
    public static var gray50: Color { asset(#function) }
    public static var gray100: Color { asset(#function) }
    public static var gray200: Color { asset(#function) }
    public static var gray300: Color { asset(#function) }
    public static var gray400: Color { asset(#function) }
    public static var gray500: Color { asset(#function) }
    public static var gray600: Color { asset(#function) }
    public static var gray700: Color { asset(#function) }
    public static var gray800: Color { asset(#function) }
    public static var gray900: Color { asset(#function) }
    public static var primary: Color { asset(#function) }
    public static var green100: Color { asset(#function) }
    public static var green200: Color { asset(#function) }
    public static var green300: Color { asset(#function) }
    public static var green400: Color { asset(#function) }
    public static var green500: Color { asset(#function) }
    public static var green600: Color { asset(#function) }
    public static var green700: Color { asset(#function) }
    public static var green800: Color { asset(#function) }
    public static var green900: Color { asset(#function) }
    public static var dim: Color { asset(#function) }
}

extension ClLogUI where Base == UIColor {
    
    private static func asset(_ name: String) -> UIColor {
        let colorName = "clLogUI_" + name
        guard let color = UIColor(named: colorName, in: .module, compatibleWith: nil) else {
            assertionFailure("can't find color asset: \(colorName)")
            return UIColor.clear
        }
        return color
    }
}

extension ClLogUI where Base == Color {
    private static func asset(_ name: String) -> Color {
        return Color(uiColor: UIColor.clLogUI.asset(name) )
    }
}
