//
//  StoryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct StoryResponseDTO: Decodable {
    let id: Int
    let totalDurationMs: Int
    let cragName: String
    let problems: [ProblemResponseDTO]
    
    func toDomain() -> ClimbStory {
        return ClimbStory(
            id: id,
            totalDurationMs: totalDurationMs,
            cragName: cragName,
            problems: problems.map { $0.toDomain() }
        )
    }
}
