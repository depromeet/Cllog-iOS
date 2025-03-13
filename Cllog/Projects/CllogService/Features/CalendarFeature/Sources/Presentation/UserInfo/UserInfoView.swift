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

enum UserInfoType {
    case normal
    case detail
}

struct UserInfoView: View {
    @Bindable private var store: StoreOf<UserInfoFeature>
    private let type: UserInfoType
    
    public init(
        type: UserInfoType,
        store: StoreOf<UserInfoFeature>
    ) {
        self.type = type
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
            switch type {
            case .normal:
                VStack(alignment: .leading, spacing: 0) {
                    Text("디퍼님,")
                        .font(.h1)
                        .foregroundColor(Color.clLogUI.primary)
                    
                    HStack(spacing: 0) {
                        Text("\(store.currentMonth)월엔 ")
                            .font(.h5)
                            .foregroundColor(Color.clLogUI.gray500)
                        Text("\(store.numOfClimbDays)일")
                            .font(.h5)
                            .foregroundColor(Color.clLogUI.primary)
                        Text(" 클라이밍했어요")
                            .font(.h5)
                            .foregroundColor(Color.clLogUI.gray500)
                    }
                }
            case .detail:
                HStack(spacing: 0) {
                    Image.clLogUI.location
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.clLogUI.white)
                    
                    Text("클라이밍파크 강남점")
                        .font(.h2)
                        .foregroundStyle(Color.clLogUI.gray10)
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
            
            if case .detail = type {
                DividerView(.horizontal)
                    .padding(.horizontal, 20)
                
                makeProblumView()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                
                DividerView(.horizontal)
                    .padding(.horizontal, 20)
                
                makeMemoView()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
            }
        }
    }
    
    // MARK: - 운동 시간
    private func makeWorkoutDurationView() -> some View {
        VStack(spacing: 0) {
            Text("\(store.currentMonth)월 총 운동 시간")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray400)
            
            Text(store.totalDurationMs.msToTimeString)
                .font(.h1)
                .foregroundStyle(Color.clLogUI.gray10)
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - 운동 시간
    private func makeAttemptCountView() -> some View {
        HStack(spacing: 0) {
            makeAttemptView(title: "총 시도 횟수", value: store.numOfClimbDays)
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
    
    // MARK: - 푼 문제
    private func makeProblumView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("푼 문제")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray400)
            
            HStack(spacing: 12) {
                Text("문제 1")
                    .font(.h4)
                    .foregroundStyle(Color.clLogUI.gray10)
                HStack(spacing: 4) {
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 24, height: 24)
                    }
                }
            }
            
            HStack(spacing: 12) {
                Text("문제 2")
                    .font(.h4)
                    .foregroundStyle(Color.clLogUI.gray10)
                
                HStack(spacing: 4) {
                    ForEach(0..<4, id: \.self) { _ in
                        Circle()
                            .fill(Color.green)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
    }
    
    // MARK: - 메모
    private func makeMemoView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("메모")
                .font(.h5)
                .foregroundStyle(Color.clLogUI.gray400)
            
            Text("클라이밍 왕초보 탈출! 홀드 잡는 감이 온다🔥")
                .font(.b1)
                .foregroundStyle(Color.clLogUI.gray50)
        }
    }
}

#Preview {
    UserInfoView(
        type: .normal,
        store: .init(initialState: UserInfoFeature.State(), reducer: {
            UserInfoFeature()
        })
    )
}
