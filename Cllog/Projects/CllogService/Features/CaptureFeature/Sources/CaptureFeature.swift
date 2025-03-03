//
//  CaptureFeature.swift
//  CaptureFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Domain
import CaptureDomain

import ComposableArchitecture

@Reducer
public struct CaptureFeature {
    
    private let logConsoleUseCase: LogConsoleUseCase
    private let captureUseCase: CaptureUseCase
    
    public struct State: Equatable {
        public init() {}
        public var destination: Destination? = nil
    }
    
    public enum Action {
        case onAppear
    }
    
    public enum Destination {
        case main
    }
    
    public init (
        logConsoleUseCase: LogConsoleUseCase,
        captureUseCase: CaptureUseCase
    ) {
        self.logConsoleUseCase = logConsoleUseCase
        self.captureUseCase = captureUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            logConsoleUseCase.executeInfo(label: "\(Self.self)", message: "action :: \(action)")
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
