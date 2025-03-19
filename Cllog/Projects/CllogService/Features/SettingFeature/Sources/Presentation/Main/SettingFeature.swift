//
//  SettingFeature.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import ComposableArchitecture
import AccountDomain
import SwiftUI

@Reducer
public struct SettingFeature {
    @Dependency(\.logoutUseCase) var logoutUseCase
    
    @ObservableState
    public struct State: Equatable {
        var profileState: ProfileFeature.State = ProfileFeature.State()
        
        var serviceItems = SettingItemType.serviceItems
        var accountItem = SettingItemType.accountItems
        
        @Presents var alert: AlertState<Action.Dialog>?
        
        public init() {}
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case profileAction(ProfileFeature.Action)
        
        case onAppear
        case backButtonTapped
        case settingItemTapped(SettingItemType)
        case logoutSuccess
        
        case logoutTapped
        case withdrawTapped
        case alert(PresentationAction<Dialog>)
        @CasePathable
        public enum Dialog: Equatable {
            case logout
            case withdraw
            case cancel
        }
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Scope(state: \.profileState, action: \.profileAction) {
            ProfileFeature()
        }
        
        Reduce(reducerCore)
            .ifLet(\.$alert, action: \.alert)
    }
}

extension SettingFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .settingItemTapped(let type):
            switch type {
            case .logout:
                return .send(.logoutTapped)
            case .deleteAccount:
                return .send(.withdrawTapped)
            default:
                return .none
            }
        case .logoutTapped:
            state.alert = AlertState {
                TextState("로그아웃")
            } actions: {
                ButtonState(action: .logout) {
                    TextState("로그아웃")
                }
                ButtonState {
                    TextState("취소")
                }
            } message: {
                TextState("로그아웃 하시겠어요?")
            }
            return .none
        case .withdrawTapped:
            state.alert = AlertState {
                TextState("탈퇴하기")
            } actions: {
                ButtonState(action: .withdraw) {
                    TextState("탈퇴하기")
                }
                ButtonState {
                    TextState("취소")
                }
            } message: {
                TextState("탈퇴하면 기록한 정보들이 사라져요.\n탈퇴하시겠어요?")
            }
            return .none
        case .alert(.presented(.logout)):
            print("로그아웃")
            return logout()
        case .alert(.presented(.withdraw)):
            print("회원탈퇴")
            return .none
        default:
            return .none
        }
    }
    
    private func logout() -> Effect<Action> {
        .run { send in
            do {
                try await logoutUseCase.execute()
                await send(.logoutSuccess)
            } catch {
                
            }
        }
    }
}
