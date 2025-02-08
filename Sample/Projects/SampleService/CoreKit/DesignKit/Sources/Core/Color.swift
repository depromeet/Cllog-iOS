//
//  Color.swift
//  DesignKit
//
//  Created by saeng lin on 2/9/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import UIKit
import SwiftUI

extension DPUI where Base == UIColor {
    
    public static var background: UIColor { asset(#function) }
}

extension DPUI where Base == Color {
     
    public static var background: Color { Color(uiColor: .dpUI.background) }
}

extension DPUI where Base == UIColor {
    
    private static func asset(_ name: String) -> UIColor {
        let colorName = "dpui_" + name
        guard let color = UIColor(named: colorName, in: .dpUIBundle, compatibleWith: nil) else {
            assertionFailure("can't find color asset: \(colorName)")
            return UIColor.clear
        }
        return color
    }
}
