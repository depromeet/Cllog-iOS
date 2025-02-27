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

extension HomeViewController {
    
    static func instance() -> HomeViewController {
        return HomeViewController()
    }
}

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clLogUI.background
        
        setupLoginView()
        
    }
    
    // TODO: SplashView에서 해당 작업 진행
    // SplashView -> Home 또는 Login으로 이동
    private func setupLoginView() {
        // TODO: Domain 주입
        let feature = LoginFeature()
        let loginView = LoginView(store: Store(initialState: LoginFeature.State()) {
            feature
        })
        
        let hostingController = UIHostingController(rootView: loginView)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}

