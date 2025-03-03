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
        
        switch store.viewState {
        case .normal:
            // 카메라 권한이 받기 전 화면
            Text("CaptureView")
                .onAppear {
                    store.send(.onAppear)
                }
            
        case .capture:
            // 카메라 권한이 있는 상태
            Text("sdf")
            
        case .noneCapturePermission:
            // 카메라 권한이 없는 상태
            Text("none capture permission")
        }
        
    }
}
