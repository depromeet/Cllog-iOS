//
//  ReadAttempt.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public struct ReadAttempt {
    public let storyId: Int
    public let problemId: Int
    public let color: Grade?
    public let crag: Crag?
    public let attempt: ReadAttemptDetail
}
