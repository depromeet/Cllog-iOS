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
import DesignKit

public struct CalendarMainView: ViewProtocol {
    let store: StoreOf<CalendarMainFeature>
    
    public init(store: StoreOf<CalendarMainFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .padding(.vertical, 32)
            .padding(.horizontal, 16)
            .background(Color.clLogUI.gray900)
    }
}

extension CalendarMainView {
    private func makeBody() -> some View {
        ScrollView {
            VStack(spacing: 20) {
                UserInfoView(
                    store: store.scope(state: \.userInfoState, action: \.userInfoAction)
                )
                
                CalendarView(
                    store: store.scope(state: \.calendarState, action: \.calendarAction)
                )
            }
        }
    }
}

#Preview {
    CalendarMainView(
        store: .init(
            initialState: CalendarMainFeature.State(),
            reducer: {
                CalendarMainFeature()
            }
        )
    )
}
