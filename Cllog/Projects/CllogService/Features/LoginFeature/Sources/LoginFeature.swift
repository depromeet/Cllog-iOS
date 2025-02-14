//
//  LoginFeature.swift
//  LoginFeature
//
//  Created by soi on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct LoginFeature {
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public init() {}
        
        var count = 0
        var isLoading = false
        var fact: String?
        var isTimerRunning = false
    }
    
    public enum Action {
        // Action은 UI에서 수행하는 작업의 이름으로 정의한다.
        case decrementButtonTapped
        case incrementButtonTapped
        case factButtonTapped
        case factResponse(String) // effect 정보 제공을 위한 액션
        case timerTick
        case toggleTimerButtonTapped
    }
    
    public enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    
    // Reducer를 이용하여 effect를 반환하며, State를 변경시킬 수 있다.
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none // 반환할 effect가 없는 경우 .none 반환
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                // 비동기 작업의 경우, 정적 메서드인 run을 사용할 수 있다.
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                
                if state.isTimerRunning {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}
