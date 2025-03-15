//
//  StoryAttemptStatusResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 시도 상태 (성공 / 실패)
enum StoryAttemptStatusResponseDTO: String, Decodable {
    case success = "SUCCESS"
    case fail = "FAILURE"
}
