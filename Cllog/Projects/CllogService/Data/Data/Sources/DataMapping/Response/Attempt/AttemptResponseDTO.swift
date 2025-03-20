//
//  AttemptResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain

struct AttemptResponseDTO: Decodable {
    let status: String
    let video: AttemptVideoResponseDTO
    
    func toDomain() -> ReadAttemptDetail {
        ReadAttemptDetail(
            status: AttemptResult(rawValue: status) ?? .complete,
            video: video.toDomain()
        )
    }
}
