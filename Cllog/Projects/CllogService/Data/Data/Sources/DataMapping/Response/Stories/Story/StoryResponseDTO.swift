//
//  StoryResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct StoryResponseDTO: Decodable {
    let id: Int
    let problems: [StoryProblemResponseDTO]
}
