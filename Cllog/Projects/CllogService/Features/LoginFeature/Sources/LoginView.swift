//
//  LoginView.swift
//  LoginFeature
//
//  Created by soi on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct LoginView: View {
    private let store: StoreOf<LoginFeature>

    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("\(store.count)")
                
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
            }
            
            Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                store.send(.toggleTimerButtonTapped)
            }
            
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
            }
        }
    }
}

