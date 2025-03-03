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
    private let permissionUseCase: CapturePermissionUseCase
    private let captureUseCase: CaptureUseCase
    
    @ObservableState
    public struct State: Equatable {
        
        public var destination: Destination? = nil
        public var viewState: ViewState = .normal
        
        public init() {}
        
    }
    
    public enum Action {
        case onAppear
        case excuteCapture
        case noneExcuteCaptue
    }
    
    public enum ViewState {
        case normal // 아직 권한을 체크하지 않는 상태
        case noneCapturePermission // 카메라이 없는 상태
        case capture // 카메라 권한이 있는 상태
    }
    
    public enum Destination {
        case main
    }
    
    public init (
        logConsoleUseCase: LogConsoleUseCase,
        permissionUseCase: CapturePermissionUseCase,
        captureUseCase: CaptureUseCase
    ) {
        self.logConsoleUseCase = logConsoleUseCase
        self.permissionUseCase = permissionUseCase
        self.captureUseCase = captureUseCase
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            logConsoleUseCase.executeInfo(label: "\(Self.self)", message: "action :: \(action)")
            switch action {
            case .onAppear:
                return .run { send in
                    do {
                        try await permissionUseCase.execute()
                        await send(.excuteCapture)
                    } catch {
                        await send(.noneExcuteCaptue)
                    }
                }
                
            case .excuteCapture:
                state.viewState = .capture
                return .none
                
            case .noneExcuteCaptue:
                state.viewState = .noneCapturePermission
                return .none
            }
        }
    }
}
