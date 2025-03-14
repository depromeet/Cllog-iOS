//
//  Date+.swift
//  Shared
//
//  Created by Junyoung on 3/12/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
}
