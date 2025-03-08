//
//  ClimbeDays.swift
//  Domain
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ClimbeDay: Hashable, Identifiable {
    public var id: UUID { UUID() }
    public let day: Date
    public var isCurrentMonth: Bool
    public let thumbnail: String?
    
    public init(
        day: Date,
        isCurrentMonth: Bool = false,
        thumbnail: String? = nil
    ) {
        self.day = day
        self.isCurrentMonth = isCurrentMonth
        self.thumbnail = thumbnail
    }
    
    public static var mock: [ClimbeDay] {
        [
            ClimbeDay(
                day: Date(),
                isCurrentMonth: true,
                thumbnail: "https://fastly.picsum.photos/id/482/200/300.jpg?hmac=sZqH9D718kRNYORntdoWP-EehCC83NaK3M-KTWvABIg"
            ),
            ClimbeDay(
                day: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
                isCurrentMonth: true,
                thumbnail: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U"
            ),
            ClimbeDay(
                day: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                isCurrentMonth: true,
                thumbnail: "https://fastly.picsum.photos/id/482/200/300.jpg?hmac=sZqH9D718kRNYORntdoWP-EehCC83NaK3M-KTWvABIg"
            ),
            ClimbeDay(
                day: Calendar.current.date(byAdding: .day, value: 4, to: Date())!,
                isCurrentMonth: true,
                thumbnail: "https://fastly.picsum.photos/id/237/200/300.jpg?hmac=TmmQSbShHz9CdQm0NkEjx1Dyh_Y984R9LpNrpvH2D_U"
            ),
        ]
    }
}
