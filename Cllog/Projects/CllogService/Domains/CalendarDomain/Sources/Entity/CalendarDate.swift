//
//  CalendarDate.swift
//  Domain
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct CalendarDate {
    public let year: Int
    public let month: Int
    public let day: Int
    
    public init(
        year: Int,
        month: Int,
        day: Int
    ) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    public var displayDate: String {
        return "\(year).\(month).\(day)"
    }
}
