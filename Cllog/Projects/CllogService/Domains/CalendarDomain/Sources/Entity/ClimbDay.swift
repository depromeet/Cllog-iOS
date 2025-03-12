//
//  ClimbeDays.swift
//  Domain
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ClimbDay: Hashable, Identifiable {
    public var id: UUID { UUID() }
    public let date: Date
    public let thumbnail: String
    public let stories: [ClimbStory]
    
    public var isCurrentMonth: Bool
    
    public init(
        date: Date,
        thumbnail: String,
        stories: [ClimbStory],
        isCurrentMonth: Bool = true
    ) {
        self.date = date
        self.thumbnail = thumbnail
        self.stories = stories
        self.isCurrentMonth = isCurrentMonth
    }
    
    public static var mock: [ClimbDay] {
        [
            ClimbDay(
                date: Date(),
                thumbnail: "https://fastly.picsum.photos/id/482/200/300.jpg?hmac=sZqH9D718kRNYORntdoWP-EehCC83NaK3M-KTWvABIg",
                stories: []
            ),
            ClimbDay(
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                thumbnail: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
                stories: []
            ),
            ClimbDay(
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                thumbnail: "https://fastly.picsum.photos/id/482/200/300.jpg?hmac=sZqH9D718kRNYORntdoWP-EehCC83NaK3M-KTWvABIg",
                stories: []
            ),
            ClimbDay(
                date: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
                thumbnail: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U",
                stories: []
            ),
        ]
    }
}
