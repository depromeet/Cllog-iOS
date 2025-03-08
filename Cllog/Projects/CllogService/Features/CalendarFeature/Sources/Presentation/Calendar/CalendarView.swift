//
//  CalendarView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import Core
import ComposableArchitecture

public struct CalendarView: ViewProtocol {
    private let store: StoreOf<CalendarFeature>
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 7)
    
    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
    }
}

extension CalendarView {
    private func makeBody() -> some View {
        VStack(spacing: 20) {
            selectMonthView()
            calendarView()
        }
        .onAppear {
            store.send(.fetchCalendar)
        }
    }
    
    private func selectMonthView() -> some View {
        HStack(spacing: 0) {
            Button {
                store.send(.previousMonthTapped)
            } label: {
                Image.clLogUI.calendarBefore
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clLogUI.gray600)
            }
            
            Text("\(monthYearString(store.selectedDate))")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray300)
            
            Button {
                store.send(.nextMonthTapped)
            } label: {
                Image.clLogUI.calendarAfter
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clLogUI.gray300)
            }
            
            Spacer()
        }
    }
    
    public func calendarView() -> some View {
        VStack(spacing: 20) {
            // 요일
            HStack {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .font(.h5)
                        .foregroundStyle(Color.clLogUI.gray500)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 51)
            
            // 달력
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(store.days, id: \.self) { date in
                    DayView(day: date) {
                        
                    }
                }
            }
        }
    }
    
    private func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView(
        store: .init(initialState: CalendarFeature.State(), reducer: {
            CalendarFeature()
        })
    )
}
