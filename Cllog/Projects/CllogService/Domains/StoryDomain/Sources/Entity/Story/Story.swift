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
    public let problems: [StoryProblem]
    
    public init(
        id: Int,
        problems: [StoryProblem]
    ) {
        self.id = id
        self.problems = problems
    }
}
