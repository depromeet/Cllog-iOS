import SwiftUI
import LoginFeature
import ComposableArchitecture

@main
struct LoginApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    static let store = Store(initialState: LoginFeature.State()) {
        LoginFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(store: LoginApp.store)
        }
    }
}
