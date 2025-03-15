//
//  ClimbProblem.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct CalendarProblem: Hashable {
    public let attemptCount: Int
    public let colorHex: String
    
    public init(
        attemptCount: Int,
        colorHex: String
    ) {
        self.attemptCount = attemptCount
        self.colorHex = colorHex
    }
}
