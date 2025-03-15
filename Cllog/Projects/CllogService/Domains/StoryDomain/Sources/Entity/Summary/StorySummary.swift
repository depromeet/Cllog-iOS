//
//  StorySummary.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StorySummary {
    public let id: Int
    public let cragName: String
    public let totalDurationMs: Int
    public let totalAttemptsCount: Int
    public let totalSuccessCount: Int
    public let totalFailCount: Int
    public let memo: String
    public let problems: [StorySummaryProblem]
    
    public init(
        id: Int,
        cragName: String,
        totalDurationMs: Int,
        totalAttemptsCount: Int,
        totalSuccessCount: Int,
        totalFailCount: Int,
        memo: String,
        problems: [StorySummaryProblem]
    ) {
        self.id = id
        self.cragName = cragName
        self.totalDurationMs = totalDurationMs
        self.totalAttemptsCount = totalAttemptsCount
        self.totalSuccessCount = totalSuccessCount
        self.totalFailCount = totalFailCount
        self.memo = memo
        self.problems = problems
    }
}
