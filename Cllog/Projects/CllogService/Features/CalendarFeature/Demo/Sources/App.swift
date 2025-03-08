import SwiftUI

import CalendarFeature

@main
struct CalendarDemoApp: App {
    var body: some Scene {
        WindowGroup {
            CalendarMainView(
                store: .init(
                    initialState: CalendarMainFeature.State(),
                    reducer: {
                        CalendarMainFeature()
                    }
                )
            )
        }
    }
}
