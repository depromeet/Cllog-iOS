//
//  Sample.swift
//  Sample
//
//  Created by Junyoung on 1/8/25.
//

import UIKit
import SwiftUI

import ComposableArchitecture

public struct MainView: View {
    
    private weak var on: UIViewController?
    private let tabViews: [AnyView]
    private let store: StoreOf<MainFeature>
    
    public init(
        on: UIViewController?,
        tabViews: [any View],
        store: StoreOf<MainFeature>
    ) {
        self.on = on
        self.store = store
        self.tabViews = tabViews.map { AnyView($0) }
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            TabView {
                ForEach(Array(tabViews.enumerated()), id: \.offset) { index, view in
                    view
                        .tabItem {
                            Text("Tab \(index + 1)")
                            Image(systemName: "\(index + 1).circle")
                        }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
