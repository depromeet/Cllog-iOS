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
import DesignKit

public struct CalendarView: ViewProtocol {
    @Bindable private var store: StoreOf<CalendarFeature>
    private let calendarColumns = Array(repeating: GridItem(.flexible(), spacing: 7), count: 7)
    
    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .bottomSheet(isPresented: $store.isPresentBottomSheet) {
                bottomSheetView()
            }
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
                store.send(.previousMonthTapped, animation: .default)
            } label: {
                Image.clLogUI.calendarBefore
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clLogUI.gray300)
            }
            
            Text("\(monthYearString(store.selectedDate))")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray300)
            
            Button {
                store.send(.nextMonthTapped, animation: .default)
            } label: {
                Image.clLogUI.calendarAfter
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(
                        store.isDisableNextMonth ?
                        Color.clLogUI.gray600 : Color.clLogUI.gray300
                    )
            }
            .disabled(store.isDisableNextMonth)
            
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
            LazyVGrid(columns: calendarColumns, spacing: 10) {
                ForEach(store.days, id: \.self) { day in
                    DayView(day: day) {
                        store.send(.dayTapped(day))
                    }
                    .disabled(!day.isCurrentMonth)
                }
            }
        }
    }
    
    private func bottomSheetView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(store.selectedDay.displayDate)
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.white)
            }
            
            Spacer(minLength: 10)
            
            Rectangle()
                .fill(Color.clLogUI.gray600)
                .frame(height: 1)
            
            Spacer(minLength: 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("클라이밍파크 강남점")
                    .font(.b1)
                    .foregroundStyle(Color.clLogUI.white)
                
                VStack {
                    ForEach(0..<5, id: \.self) { _ in
                        ClimbingCard() {
                            
                        }
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
