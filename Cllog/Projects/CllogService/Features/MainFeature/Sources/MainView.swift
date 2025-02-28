//
//  Sample.swift
//  Sample
//
//  Created by Junyoung on 1/8/25.
//

import UIKit
import SwiftUI

import DesignKit

import ComposableArchitecture

public struct MainView: View {
    
    private weak var on: UIViewController?
    private let tabViews: [AnyView]
    private let store: StoreOf<MainFeature>
    
    @State private var selectedTab = 0
    
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
            TabView(selection: $selectedTab) {
                ForEach(Array(tabViews.enumerated()), id: \.offset) { index, view in
                    view
                        .tabItem {
                            Image(
                                selectedTab == index ? "\(viewStore.state.selectedImageNames[index])":
                                    "\(viewStore.state.unselectedImageNames[index])",
                                bundle: .clLogUIBundle
                            )
                        }
                        .toolbarBackground(Color.clLogUI.gray700, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
