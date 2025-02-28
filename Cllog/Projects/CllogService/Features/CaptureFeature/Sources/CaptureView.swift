//
//  CaptureView.swift
//  CaptureFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public struct CaptureView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<CaptureFeature>
    
    public init(
        on: UIViewController?,
        store: StoreOf<CaptureFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Text("CaptureView")
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}
