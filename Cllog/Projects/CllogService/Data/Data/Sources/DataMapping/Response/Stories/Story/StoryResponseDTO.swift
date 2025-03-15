//
//  StoryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import StoryDomain

public struct StoryResponseDTO: Decodable {
    let id: Int
    let problems: [StoryProblemResponseDTO]
    
    func toDomain() -> Story {
        return Story(
            id: id,
            problems: problems.map { $0.toDomain() }
        )
    }
}
