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
}

public enum TextInputType {
    case filed
    case editor
}

public enum TextInputState {
    case normal
    case disable
    case error
    
    var backgroundColor: Color {
        switch self {
        case .normal, .disable, .error:
            return .clLogUI.gray900

        }
    }
    
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
