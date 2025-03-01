//
//  CaptureFeature.swift
//  CaptureFeature
//
//  Created by saeng lin on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

//import Dependencies
import ComposableArchitecture

@Reducer
public struct CaptureFeature {
    
    private let logger: (String) -> Void
    
    @Dependency(\.capturePermissionable) var capturePermission
    
    public struct State: Equatable {
        public init() {}
        public var destination: Destination? = nil
        public var isRecording: Bool = false
    }
    
    public enum Action {
        case onAppear
        case startRecording
    }
    
    public enum Destination {
        case main
    }
    
    public init (
        logger: @escaping @Sendable (String) -> Void
    ) {
        self.logger = logger
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            logger("\(Self.self) action :: \(action)")
            switch action {
            case .onAppear:
                return onPermissionAction()
                
            case .startRecording:
                state.isRecording.toggle()
                return .none
            }
        }
    }
}

extension CaptureFeature {
    
    private func onPermissionAction() -> Effect<Action> {
        return .run { [capturePermission] send in
            if await capturePermission.isPermission() == false {
                do {
                    try await capturePermission.requestPermission()
                } catch {
                    
                }
            }
        }
    }
}
