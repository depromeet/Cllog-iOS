//
//  ClLogger.swift
//  Cllog
//
//  Created by saeng lin on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Starlink
import Pulse

enum ClLogger {
    
    public static func message(
        label: String = "",
        level: LoggerStore.Level = .debug,
        message: String
    ) {
        ConsoleWindow.shared.message(
            label: label,
            level: .info,
            message: message)
    }
}
