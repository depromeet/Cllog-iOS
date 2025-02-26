import SwiftUI
import LoginFeature

import ComposableArchitecture

@main
struct LoginApp: App {
    
    static let store = Store(initialState: LoginFeature.State()) {
        LoginFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(
                store: LoginApp.store
            )
        }
    }
}
