//
//  SettingFeature.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import SwiftUI

@Reducer
public struct SettingFeature {
    @ObservableState
    public struct State: Equatable {
        var profileState: ProfileFeature.State = ProfileFeature.State()
        
        var serviceItems = SettingItemType.serviceItems
        var accountItem = SettingItemType.accountItems
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case profileAction(ProfileFeature.Action)
        
        case onAppear
        case backButtonTapped
        case settingItemTapped(SettingItemType)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Scope(state: \.profileState, action: \.profileAction) {
            ProfileFeature()
        }
        
        Reduce(reducerCore)
    }
}

extension SettingFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .settingItemTapped(let type):
            return .none
        default:
            return .none
        }
    }
}
