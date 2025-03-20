//
//  AttemptVideoResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct AttemptVideoResponseDTO: Decodable {
    let id: Int
    let localPath: String
    let thumbnailUrl: String
    let durationMs: Int
    let stamps: [AttemptStampResponseDTO]
}
