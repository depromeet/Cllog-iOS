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
            .background(Color.clLogUI.background)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension UserInfoView {
    private func makeBody() -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 0) {
                Text("디퍼님,")
                    .font(.h1)
                    .foregroundColor(Color.clLogUI.primary)
                
                Text("n월에 n일 클라이밍했어요")
                    .font(.h1)
                    .foregroundColor(Color.clLogUI.gray500)
            }
            Spacer()
            
            DropdownButton(isOpen: $store.isOpen) { }
        }
        .padding(20)
        .onTapGesture {
            store.send(.dropdownTapped, animation: .default)
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
