//
//  DetailAttemptResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct DetailAttemptResponseDTO: Decodable {
    let storyId: Int
    let problemId: Int
    let color: FolderAttemptColorResponseDTO?
    let crag: FolderCragResponseDTO?
    let attempt: AttemptResponseDTO
}
