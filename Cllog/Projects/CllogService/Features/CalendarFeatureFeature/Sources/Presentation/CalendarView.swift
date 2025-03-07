//
//  CalendarView.swift
//  CalendarFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct CalendarView: View {
    let store: StoreOf<FolderFeature>
    
    var body: some View {
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
