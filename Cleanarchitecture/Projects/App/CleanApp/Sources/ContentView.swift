import SwiftUI

import Account

public struct ContentView: View {
    
    private let account: Account = .init()
    
    private enum ViewState {
        case loading
        case autoLogin
    }
    
    @State
    private var viewState: ViewState = .loading
    
    public init() {}

    public var body: some View {
        Text("\(viewState)")
            .task {
                do {
                    print("시작")
                    viewState = .loading
                    try await account.start()
                    viewState = .autoLogin
                } catch {
                    
                }
            }
            .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
