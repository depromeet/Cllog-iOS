//
//  HomeViewController.swift
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

import LoginFeature
import Shared

public extension HomeViewController {
    
    static func instance() -> UIViewController {
        return HomeViewController()
    }
}

public final class HomeViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        let homeView = HomeView(
            on: self,
            store: StoreOf<HomeFeature>(
                initialState: HomeFeature.State(),
                reducer: { ClLogDI.container.resolve(HomeFeature.self) })
        )
        
        let hostingController = UIHostingController(
            rootView: homeView)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
