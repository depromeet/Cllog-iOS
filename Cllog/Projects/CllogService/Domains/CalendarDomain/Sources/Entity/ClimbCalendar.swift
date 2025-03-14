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
    public let days: [ClimbDay]
    
    public init(
        numOfClimbDays: Int,
        totalDurationMs: Int,
        days: [ClimbDay]
    ) {
        self.numOfClimbDays = numOfClimbDays
        self.totalDurationMs = totalDurationMs
        self.days = days
    }
}
