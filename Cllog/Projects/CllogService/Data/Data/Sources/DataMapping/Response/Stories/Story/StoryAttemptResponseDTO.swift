//
//  StoryAttemptResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

// 클라이밍 시도 정보
struct StoryAttemptResponseDTO: Decodable {
    let status: StoryAttemptStatusResponseDTO
    let video: StoryVideoResponseDTO
}
