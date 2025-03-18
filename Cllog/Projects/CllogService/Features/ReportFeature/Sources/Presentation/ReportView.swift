//
//  ReportView.swift
//  ReportFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct ReportView: View {
    private let store: StoreOf<ReportFeature>
    
    public init(store: StoreOf<ReportFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clLogUI.gray800)

    }
}

extension ReportView {
    private func makeBody() -> some View {
        VStack(spacing: 0) {
            AppBar {
                Text("나의 클라이밍 리포트")
                    .font(.h3)
                    .foregroundStyle(Color.clLogUI.gray10)
            } rightContent: {
                Button {
                    store.send(.settingTapped)
                } label: {
                    Image.clLogUI.setting
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clLogUI.white)
                }
            }
            
            Spacer()
        }
    }
}
