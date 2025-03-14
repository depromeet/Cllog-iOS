//
//  Int+.swift
//  Shared
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public extension Int {
    func toTimeString() -> String {
        guard self > 0 else { return "00:00:00"}
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
