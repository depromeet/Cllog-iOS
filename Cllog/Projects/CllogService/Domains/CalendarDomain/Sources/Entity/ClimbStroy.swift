//
//  ClimbStroy.swift
//  CalendarDomain
//
//  Created by Junyoung on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ClimbStory: Hashable {
    public static func == (lhs: ClimbStory, rhs: ClimbStory) -> Bool {
        rhs.id == lhs.id
    }
    
    let id: Int
    let totalDurationMs: Int
    let cragName: String
    let problems: [ClimbProblem]
}
