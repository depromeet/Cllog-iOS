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

public protocol FutureMonthCheckerUseCase {
    func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool
}

public struct FutureMonthChecker: FutureMonthCheckerUseCase {
    public init() {}
    
    public func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool {
        guard let selectedYear = selectedMonth.year,
              let selectedMonth = selectedMonth.month,
              let currentYear = currentMonth.year,
              let currentMonth = currentMonth.month
        else {
            return true
        }
        
        if selectedYear == currentYear {
            return selectedMonth >= currentMonth
        } else {
            return false
        }
    }
}

public struct MockMonthLimit: FutureMonthCheckerUseCase {
    public func execute(selectedMonth: DateComponents, currentMonth: DateComponents) -> Bool {
        return false
    }
}

public enum MonthLimitDependencyKey: DependencyKey {
    public static var liveValue: any FutureMonthCheckerUseCase = ClLogDI.container.resolve(FutureMonthCheckerUseCase.self)!
    
    public static var testValue: any FutureMonthCheckerUseCase = MockMonthLimit()
    
    public static var previewValue: any FutureMonthCheckerUseCase = MockMonthLimit()
}

public extension DependencyValues {
    var futureMonthCheckerUseCase: any FutureMonthCheckerUseCase {
        get { self[MonthLimitDependencyKey.self] }
        set { self[MonthLimitDependencyKey.self] = newValue }
    }
}

