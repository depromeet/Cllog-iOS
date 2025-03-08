//
//  UserInfoView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

struct UserInfoView: View {
    @Bindable private var store: StoreOf<UserInfoFeature>
    
    public init(store: StoreOf<UserInfoFeature>) {
        self.store = store
    }
    
    var body: some View {
        makeBody()
            .background(Color.clLogUI.gray900)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension UserInfoView {
    private func makeBody() -> some View {
        VStack {
            makeInfoView()
                .contentShape(Rectangle())
                .onTapGesture {
                    store.send(.dropdownTapped, animation: .default)
                }
            
            if store.isOpen {
                makeDropdownView()
            }
        }
    }
    
    // MARK: - InfoView
    private func makeInfoView() -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text("디퍼님,")
                    .font(.h1)
                    .foregroundColor(Color.clLogUI.primary)
                
                HStack(spacing: 0) {
                    Text("3월엔 ")
                        .font(.h5)
                        .foregroundColor(Color.clLogUI.gray500)
                    Text("15일")
                        .font(.h5)
                        .foregroundColor(Color.clLogUI.primary)
                    Text(" 클라이밍했어요")
                        .font(.h5)
                        .foregroundColor(Color.clLogUI.gray500)
                }
            }
            
            Spacer()
            
            DropdownButton(isOpen: $store.isOpen) { }
                .allowsHitTesting(false)
                .padding(.trailing, 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    // MARK: - 드롭다운 뷰
    private func makeDropdownView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            DividerView(.horizontal)
                .padding(.horizontal, 20)
            
            makeWorkoutDurationView()
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
            DividerView(.horizontal)
                .padding(.horizontal, 20)
            
            makeAttemptCountView()
                .padding(.horizontal, 14)
                .padding(.vertical, 16)
        }
    }
    
    // MARK: - 운동 시간
    private func makeWorkoutDurationView() -> some View {
        VStack(spacing: 0) {
            Text("2월 총 운동 시간")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray400)
            
            Text("00:32:10")
                .font(.h1)
                .foregroundStyle(Color.clLogUI.gray10)
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - 운동 시간
    private func makeAttemptCountView() -> some View {
        HStack(spacing: 0) {
            makeAttemptView(title: "총 시도 횟수", value: 10)
                .frame(maxWidth: .infinity)
            
            DividerView(.vertical)
            
            makeAttemptView(title: "완등 횟수", value: 3)
                .frame(maxWidth: .infinity)
            
            DividerView(.vertical)
            
            makeAttemptView(title: "실패 횟수", value: 7)
                .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - 운동시간 컴포넌트
    private func makeAttemptView(title: String, value: Int) -> some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray400)
            
            Text("\(value)")
                .font(.h1)
                .foregroundStyle(Color.clLogUI.gray10)
        }
    }
}

#Preview {
    UserInfoView(
        store: .init(initialState: UserInfoFeature.State(), reducer: {
            UserInfoFeature()
        })
    )
}
