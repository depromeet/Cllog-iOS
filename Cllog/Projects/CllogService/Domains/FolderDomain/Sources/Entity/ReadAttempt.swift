//
//  ReadAttempt.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct ReadAttempt: Hashable, Identifiable {
    public var id: UUID
    
    public let storyId: Int
    public let problemId: Int
    public let grade: Grade?
    public let crag: Crag?
    public let result: AttemptResult?
    public let attempt: ReadAttemptDetail
    
    public init(id: UUID = UUID(), storyId: Int, problemId: Int, grade: Grade?, crag: Crag?, result: AttemptResult?, attempt: ReadAttemptDetail) {
        self.id = id
        self.storyId = storyId
        self.problemId = problemId
        self.grade = grade
        self.crag = crag
        self.result = result
        self.attempt = attempt
    }
}
