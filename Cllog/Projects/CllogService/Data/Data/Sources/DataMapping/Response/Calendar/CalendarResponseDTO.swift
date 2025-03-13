//
//  CalendarResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct CalendarResponseDTO: Decodable {
    let numOfClimbDays: Int
    let totalDurationMs: Int
    let days: [DayResponseDTO]
    
    func toDomain() -> ClimbCalendar {
        return ClimbCalendar(
            numOfClimbDays: numOfClimbDays,
            totalDurationMs: totalDurationMs,
            days: days.map { $0.toDomain() }
        )
    }
}
