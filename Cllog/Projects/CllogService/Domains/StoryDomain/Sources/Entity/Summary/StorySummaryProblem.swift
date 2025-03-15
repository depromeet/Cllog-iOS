//
//  StorySummaryProblem.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StorySummaryProblem {
    public let id: Int
    public let attemptCount: Int
    public let colorHex: String
    
    public init(
        id: Int,
        attemptCount: Int,
        colorHex: String
    ) {
        self.id = id
        self.attemptCount = attemptCount
        self.colorHex = colorHex
    }
}
