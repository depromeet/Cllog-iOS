//
//  MonthLimitUseCase.swift
//  Domain
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol MonthLimitUseCase {
    func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool
}

public struct MonthLimit: MonthLimitUseCase {
    public init() {}
    
    public func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool {
        guard let selectedYear = selectedMonth.year,
              let selectedMonth = selectedMonth.month,
              let currentYear = currentMonth.year,
              let currentMonth = currentMonth.month
        else {
            return true
        }
        
        guard selectedYear >= currentYear else {
            return true
        }
        
        return selectedMonth >= currentMonth
    }
}

public struct MockMonthLimit: MonthLimitUseCase {
    public func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool {
        return false
    }
}

public enum MonthLimitDependencyKey: DependencyKey {
    public static var liveValue: any MonthLimitUseCase = ClLogDI.container.resolve(MonthLimitUseCase.self)!
    
    public static var testValue: any MonthLimitUseCase = MockMonthLimit()
    
    public static var previewValue: any MonthLimitUseCase = MockMonthLimit()
}

public extension DependencyValues {
    var monthLimitUseCase: any MonthLimitUseCase {
        get { self[MonthLimitDependencyKey.self] }
        set { self[MonthLimitDependencyKey.self] = newValue }
    }
}

