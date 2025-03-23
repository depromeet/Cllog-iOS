//
//  TextConfiguration.swift
//  DesignKit
//
//  Created by Junyoung on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI

public struct TextInputConfiguration {
    var state: TextInputState
    var type: TextInputType
    var background: TextInputBackground
}

public enum TextInputType {
    case filed
    case editor
}

public enum TextInputBackground {
    case gray800
    case gray900
    
    var color: Color {
        switch self {
        case .gray800:
            return Color.clLogUI.gray800
        case .gray900:
            return Color.clLogUI.gray900
        }
    }
}

public enum TextInputState {
    case normal
    case disable
    case error
    
    var foregroundColor: Color {
        switch self {
        case .normal:
            return .clLogUI.gray50
        case .disable:
            return .clLogUI.gray600
        case .error:
            return .clLogUI.fail
        }
    }
}
