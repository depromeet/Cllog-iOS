//
//  ClimbStory.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ClimbStory: Hashable {
    public static func == (lhs: ClimbStory, rhs: ClimbStory) -> Bool {
        rhs.id == lhs.id
    }
    
    public let id: Int
    public let totalDurationMs: Int
    public let cragName: String
    public let problems: [ClimbProblem]
    
    public init(
        id: Int,
        totalDurationMs: Int,
        cragName: String,
        problems: [ClimbProblem]
    ) {
        self.id = id
        self.totalDurationMs = totalDurationMs
        self.cragName = cragName
        self.problems = problems
    }
}
