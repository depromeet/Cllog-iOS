//
//  StoryAttempt.swift
//  StoryDomain
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 클라이밍 시도 정보
public struct StoryAttempt {
    public let status: StoryAttemptStatus
    public let video: StoryVideo
    
    public init(
        status: StoryAttemptStatus,
        video: StoryVideo
    ) {
        self.status = status
        self.video = video
    }
}
