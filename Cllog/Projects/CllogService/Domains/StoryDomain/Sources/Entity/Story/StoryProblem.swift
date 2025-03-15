//
//  StoryProblem.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 클라이밍 문제 정보
public struct StoryProblem {
    public let id: Int
    public let attempts: [StoryAttempt]
    public let successCount: Int
    public let failCount: Int
    
    public init(
        id: Int,
        attempts: [StoryAttempt],
        successCount: Int,
        failCount: Int
    ) {
        self.id = id
        self.attempts = attempts
        self.successCount = successCount
        self.failCount = failCount
    }
}
