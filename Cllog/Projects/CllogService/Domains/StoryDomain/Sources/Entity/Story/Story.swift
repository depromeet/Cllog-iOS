//
//  Story.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Story: Equatable {
    public let id: Int
    public let totalDurationMs: Int
    public let problems: [StoryProblem]
    public let colorHex: String?
    
    public init(
        id: Int,
        totalDurationMs: Int,
        problems: [StoryProblem],
        colorHex: String?
    ) {
        self.id = id
        self.totalDurationMs = totalDurationMs
        self.problems = problems
        self.colorHex = colorHex
    }
}
