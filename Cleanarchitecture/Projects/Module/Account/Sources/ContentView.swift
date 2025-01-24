import SwiftUI

public struct ContentView: View {
    
    private var account: Account = .init()
    
    enum ViewState {
        case loading
        case autoLogin
        case kitout
    }
    
    @State
    private var state: ViewState = .loading
    
    public init() {}

    public var body: some View {
        Text("\(state)")
            .task {
                do {
                    try await account.start()
                    state = .autoLogin
                } catch {
                    
                }
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
