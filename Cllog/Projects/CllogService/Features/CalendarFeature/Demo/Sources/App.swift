import SwiftUI

import CalendarFeature
import Shared
import Domain

@main
struct CalendarDemoApp: App {
    
    init() {
        ClLogDI.container.register(MonthLimitUseCase.self) { _ in
            MonthLimit()
        }
    }
    
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
