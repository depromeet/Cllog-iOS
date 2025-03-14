//
//  MainView.swift
//  CllogService
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

/// Apple Module
import UIKit
import SwiftUI

/// 내부 Module
import VideoFeature

/// 외부 Module
import ComposableArchitecture

/// 구현부
public struct MainView: View {
    
    // MARK: - Private Properties
    private weak var on: UIViewController?
    private let store: StoreOf<MainFeature>
    
    @State private var selectedTab: Int = 0
    
    /// 초기화
    /// - Parameters:
    ///   - on: Root UIViewController
    ///   - store: MainFeature
    public init(
        on: UIViewController?,
        store: StoreOf<MainFeature>
    ) {
        self.store = store
    }
    
    public var body: some View {
        bodyView
    }
}

private extension MainView {
    
    var bodyView: some View {
        ZStack {
            
            // 탭 뷰
            tabView
            
            // 영상 녹화 화면
            IfLetStore(store.scope(state: \.recordState, action: \.recordFeatureAction)) { [weak on] store in
                RecordView(on: on, store: store)
            }
        }
    }
}

// MARK: - TabView
private extension MainView {
    var tabView: some View {
        // 메인 화면 전체
        TabView(selection: $selectedTab) {
            ForEach(Array([AnyView(folderTabbarView), AnyView(videoTabbarView), AnyView(reportTabbarView)].enumerated()), id: \.offset) { index, view in
                view
                    .tabItem {
                        selectedTab == index ? Image("icn_folder_selected", bundle: .clLogUIBundle) : Image("icn_folder_unselected", bundle: .clLogUIBundle)
                    }
                    .toolbarBackground(Color.clLogUI.gray700, for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                    .onAppear {
                        store.send(.selectedTab(index))
                    }
            }
        }
    }
}

// MARK: - Folder Tabbar View
private extension MainView {
    // 준영
    var folderTabbarView: some View  {
        Text("1")
    }
}

// MARK: - Video Tabbar View
private extension MainView {
    
    var videoTabbarView: some View {
        VideoView(
            on: on,
            store: store.scope(state: \.vidoeTabState, action: \.videoTabAction)
        )
    }
}

// MARK: - Report Tabbar View
private extension MainView {
    
    var reportTabbarView: some View {
        Text("3")
    }
}
