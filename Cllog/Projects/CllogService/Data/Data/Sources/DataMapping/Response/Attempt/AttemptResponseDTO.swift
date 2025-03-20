//
//  AttemptResponseDTO.swift
//  Data
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct AttemptResponseDTO: Decodable {
    let status: String
    let video: AttemptVideoResponseDTO
}
