//
//  CoordinatorFeature.swift
//  CllogService
//
//  Created by Junyoung Lee on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import CalendarFeature
import SettingFeature

@Reducer
public struct RouterFeature {
    @MainActor
    public static var initialStore: StoreOf<RouterFeature> {
        Store(
            initialState: State(),
            reducer: { RouterFeature() }
        )
    }
    
    public init() {}
    
    @ObservableState
    public struct State {
        var rootState: RootFeature.State = RootFeature.State()
        var path = StackState<Path.State>()
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case rootAction(RootFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.rootState, action: \.rootAction) {
            RootFeature()
        }
        
        Reduce(reducerCore)
            .forEach(\.path, action: \.path)
    }
}

extension RouterFeature {
    public func reducerCore(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .rootAction(let action):
            return rootCore(state: &state, action: action)
        case .path(.element(id: let id, action: .calendarDetail(.backButtonTapped))):
            // 캘린더 상세 페이지 pop
            state.path.pop(from: id)
            return .none
        case .path(.element(id: let id, action: .setting(.backButtonTapped))):
            state.path.pop(from: id)
            return .none
        case .path(.element(id: let id, action: .setting(.exitToStart))):
            state.path.pop(from: id)
            state.rootState.mainState = nil
            state.rootState.loginState = .init()
            return .none
        default:
            return .none
        }
    }
    
    public func rootCore(state: inout State, action: RootFeature.Action) -> Effect<Action> {
        switch action {
        case let .mainAction(.routerAction(.pushToCalendarDetail(storyId))):
            // 캘린더 상세 페이지 push
            state.path.append(.calendarDetail(CalendarDetailFeature.State(storyId: storyId)))
            return .none
        case .mainAction(.routerAction(.pushToSetting)):
            state.path.append(.setting(SettingFeature.State()))
            return .none
        default:
            return .none
        }
    }
}
