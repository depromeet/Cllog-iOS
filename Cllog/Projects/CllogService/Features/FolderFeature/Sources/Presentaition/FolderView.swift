//
//  FolderView.swift
//  FolderFeatureFeature
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import Core
import ComposableArchitecture

public struct FolderView: ViewProtocol {
    let store: StoreOf<FolderFeature>
    
    public init(store: StoreOf<FolderFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Folder")
    }
}

#Preview {
    FolderView(
        store: .init(
            initialState: FolderFeature.State(),
            reducer: {
                FolderFeature()
            }
        )
    )
}
