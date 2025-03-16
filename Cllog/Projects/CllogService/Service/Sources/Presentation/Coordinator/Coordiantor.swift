//
//  RootViewController.swift
//  Cllog
//
//  Created by saeng lin on 2/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import DesignKit
import Starlink
import Pulse
import PulseUI
import PulseProxy
import SwiftUI
import ComposableArchitecture
import CalendarFeature

import LoginFeature
import Shared

public protocol Coordinator: AnyObject {
    var navigationController: BaseNavigationController { get }
    func start()
    func pushToCalendarDetail(_ storyId: Int)
    func pop()
}

// MARK: RootCoordinator
public final class DefaultCoordinator: Coordinator {
    public var navigationController: BaseNavigationController
    
    public init() {
        self.navigationController = BaseNavigationController()
    }
    
    public func start() {
        var feature = RootFeature()
        feature.coordinator = self
        
        let rootView = RootView(
            store: StoreOf<RootFeature>(
                initialState: RootFeature.State(),
                reducer: { feature })
        )
        
        let hostingController = UIHostingController(
            rootView: rootView)
        
        navigationController.viewControllers = [hostingController]
    }
    
    public func pushToCalendarDetail(_ storyId: Int) {
        let view = CalendarDetailView(
            store: .init(
                initialState: CalendarDetailFeature.State(storyId: storyId),
                reducer: {
                    CalendarDetailFeature()
                }
            )
        )
        
        let hostVC = UIHostingController(rootView: view)
        navigationController.pushViewController(hostVC, animated: true)
    }
    
    public func pop() {
        navigationController.popViewController(animated: true)
    }
}
