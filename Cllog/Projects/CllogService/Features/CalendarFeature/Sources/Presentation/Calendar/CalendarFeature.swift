//
//  CalendarFeature.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Domain

@Reducer
public struct CalendarFeature {
    
    private let calendar = Calendar.current
    
    @ObservableState
    public struct State {
        var selectedDate: Date = Date()
        var days: [ClimbeDay] = []
        public init() {
            
        }
    }
    
    public enum Action {
        case previousMonthTapped
        case nextMonthTapped
        case updateDays([ClimbeDay])
        
        case fetchCalendar
        case fetchSuccess([ClimbeDay])
        case fetchFailure(Error)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .previousMonthTapped:
                if let newDate = calendar.date(byAdding: .month, value: -1, to: state.selectedDate) {
                    state.selectedDate = newDate
                    return .send(.fetchCalendar)
                }
                return .none
            case .nextMonthTapped:
                if let newDate = calendar.date(byAdding: .month, value: 1, to: state.selectedDate) {
                    state.selectedDate = newDate
                    return .send(.fetchCalendar)
                }
                return .none
            case .updateDays(let days):
                state.days = getDays(for: state.selectedDate, calendarDay: days)
                return .none
                
            case .fetchCalendar:
                return fetchCalendar(state.selectedDate)
            case .fetchSuccess(let days):
                return .send(.updateDays(days))
            case .fetchFailure(let error):
                print(error)
                return .none
            }
        }
    }
}

extension CalendarFeature {
    private func fetchCalendar(_ date: Date) -> Effect<Action> {
        .run { send in
            let data = ClimbeDay.mock
            await send(.fetchSuccess(data))
        }
    }
    
    private func getDays(for date: Date, calendarDay: [ClimbeDay]) -> [ClimbeDay] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else { return [] }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        var tempDays: [ClimbeDay] = []
        
        //  이전 달의 남은 날짜 추가
        if firstWeekday > 0,
           let previousMonth = calendar.date(byAdding: .month, value: -1, to: firstDayOfMonth),
           let previousMonthDays = calendar.range(of: .day, in: .month, for: previousMonth) {
            
            let startDay = max(1, min(previousMonthDays.count, previousMonthDays.count - firstWeekday + 1)) // ✅ 범위 조정
            let endDay = previousMonthDays.count
            
            for day in startDay...endDay {
                if let date = calendar.date(bySetting: .day, value: day, of: previousMonth) {
                    tempDays.append(ClimbeDay(day: date, isCurrentMonth: false))
                }
            }
        }
        
        //  현재 달의 날짜 추가
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: firstDayOfMonth) {
                
                // 서버 데이터에서 해당 날짜의 이벤트 찾기
                let matchedEvent = calendarDay.first(where: { calendar.isDate($0.day, inSameDayAs: date) })
                
                let calendarDay = ClimbeDay(
                    day: date,
                    isCurrentMonth: true,
                    thumbnail: matchedEvent?.thumbnail
                )
                
                tempDays.append(calendarDay)
            }
        }
        
        //  남은 칸 계산 (7일 단위 유지)
        let remainder = tempDays.count % 7
        if remainder > 0 {
            let nextMonthStart = 1
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth) {
                for day in nextMonthStart..<(7 - remainder + 1) {
                    if let date = calendar.date(bySetting: .day, value: day, of: nextMonth) {
                        tempDays.append(ClimbeDay(day: date, isCurrentMonth: false))
                    }
                }
            }
        }
        
        return tempDays
    }
}
