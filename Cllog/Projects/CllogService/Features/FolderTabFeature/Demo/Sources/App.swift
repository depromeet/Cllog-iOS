import SwiftUI
import FolderTabFeature

@main
struct AppModule: App {
    var body: some Scene {
        WindowGroup {
            FolderTabView(
                store: .init(
                    initialState: FolderTabFeature.State(),
                    reducer: {
                        FolderTabFeature()
                    }
                )
            )
        }
    }
}
