//
//  DayResponseDTO.swift
//  Data
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CalendarDomain

public struct DayResponseDTO: Decodable {
    public let date: String
    public let thumbnail: String
    public let stories: [StoryResponseDTO]
    
    func toDomain() -> ClimbDay {
        return ClimbDay(
            date: date.toDate(),
            thumbnail: thumbnail,
            stories: stories.map { $0.toDomain() }
        )
    }
}
