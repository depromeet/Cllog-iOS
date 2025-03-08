//
//  CalendarView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct CalendarView: View {
    let store: StoreOf<CalendarFeature>
    
    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CalendarView(
        store: .init(initialState: CalendarFeature.State(), reducer: {
            CalendarFeature()
        })
    )
}
