//
//  StorySummaryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StorySummaryResponseDTO: Decodable {
    let id: Int
    let cragName: String
    let totalDurationMs: Int
    let totalAttemptsCount: Int
    let totalSuccessCount: Int
    let totalFailCount: Int
    let memo: String
    let problems: [StorySummaryProblemResponseDTO]
}
