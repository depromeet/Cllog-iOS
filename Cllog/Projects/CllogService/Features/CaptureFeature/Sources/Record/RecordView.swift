//
//  RecordView.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

import DesignKit

import ComposableArchitecture

public struct RecordView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<RecordFeature>
    
    public init(
        on: UIViewController?,
        store: StoreOf<RecordFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onTapGesture {
                store.send(.onClose)
            }
    }
    
    
}

private extension RecordView {
    
    @ViewBuilder
    var bodyView: some View {
        ZStack {
            switch store.viewState {
            case .recording:
                recordView
                
            case .recorded:
                Text("recorded")
                
            case .editing:
                Text("")
                
            case .completed:
                Text("")
            }
        }
    }
}

// MARK: - Record
private extension RecordView {
    
    @ViewBuilder
    var recordView: some View {
        Color.gray
            .ignoresSafeArea()

        VStack {
            
            Spacer()
            
            RecodingButton(isRecoding: .init(get: {
                return true
            }, set: { newValue in
                
            }), onTapped: {
                store.send(.onClose)
            }).padding(.bottom, 40)
        }
    }
}
