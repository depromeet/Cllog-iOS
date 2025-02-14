//
//  SampleApp.swift
//  SampleApp
//
//  Created by Junyoung on 1/8/25.
//

import SwiftUI
import LoginFeature
import ComposableArchitecture

@main
struct SampleApp: App {
    static let store = Store(initialState: LoginFeature.State()) {
        LoginFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(store: SampleApp.store)
        }
    }
}
