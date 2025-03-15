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
import FolderTabFeature

/// 외부 Module
import ComposableArchitecture
import FolderFeature
import CalendarFeature

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
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onChange(of: store.pushToCalendarDetail) { oldValue, newValue in
                guard let newValue else { return }
                let view = CalendarDetailView(store: store.scope(state: \.calendarDetailState, action: \.calendarDetailAction))
                let vc = UIHostingController(rootView: view)
                on?.navigationController?.pushViewController(vc, animated: true)
            }
    }
}

private extension MainView {
    
    var bodyView: some View {
        ZStack {
            
            // 탭 뷰
            tabView
            
            // 영상 녹화 화면
            IfLetStore(store.scope(state: \.recordState, action: \.recordFeatureAction)) { [weak on] store in
                RecordHomeView(on: on, store: store)
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
                    .safeAreaPadding()
            }
        }
    }
}

// MARK: - Folder Tabbar View
private extension MainView {
    var folderTabbarView: some View  {
        FolderTabView(
            store: store.scope(
                state: \.folderTabState,
                action: \.folderTabAction
            ),
            folderView: FolderView(
                store: store.scope(
                    state: \.folderState,
                    action: \.folderAction
                )
            ),
            calendarView: CalendarMainView(
                store: store.scope(
                    state: \.calendarMainState,
                    action: \.calendarMainAction
                )
            )
        )
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
