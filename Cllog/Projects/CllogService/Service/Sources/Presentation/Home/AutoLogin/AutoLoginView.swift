//
//  AutoLoginView.swift
//  CllogService
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct AutoLoginView: View {
    
    private let store: StoreOf<AutoLoginFeature>
    
    init(store: StoreOf<AutoLoginFeature>) {
        self.store = store
    }
    
    var body: some View {
        Text("autoLogin")
            .onAppear {
                store.send(.onAppear)
            }
    }
}
