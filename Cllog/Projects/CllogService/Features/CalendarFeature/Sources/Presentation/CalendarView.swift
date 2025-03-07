//
//  CalendarView.swift
//  CalendarFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import Core
import ComposableArchitecture

public struct CalendarView: ViewProtocol {
    let store: StoreOf<CalendarFeature>
    
    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("CelendarView")
    }
}

#Preview {
    CalendarView(
        store: .init(
            initialState: CalendarFeature.State(),
            reducer: {
                CalendarFeature()
            }
        )
    )
}
