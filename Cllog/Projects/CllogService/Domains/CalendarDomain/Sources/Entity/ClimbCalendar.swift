//
//  Calendar.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ClimbCalendar {
    public let numOfClimbDays: Int
    public let totalDurationMs: Int
    public let totalAttemptCount: Int
    public let successAttemptCount: Int
    public let failAttemptCount: Int
    public let days: [CalendarDay]
    
    public init(
        numOfClimbDays: Int,
        totalDurationMs: Int,
        totalAttemptCount: Int,
        successAttemptCount: Int,
        failAttemptCount: Int,
        days: [CalendarDay]
    ) {
        self.numOfClimbDays = numOfClimbDays
        self.totalDurationMs = totalDurationMs
        self.totalAttemptCount = totalAttemptCount
        self.successAttemptCount = successAttemptCount
        self.failAttemptCount = failAttemptCount
        self.days = days
    }
}
