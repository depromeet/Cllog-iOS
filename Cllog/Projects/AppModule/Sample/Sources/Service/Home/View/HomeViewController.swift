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
        
        configure()
    }
    
    private func configure() {
        let homeView = HomeView(
            on: self,
            store: StoreOf<HomeFeature>(
                initialState: HomeFeature.State(),
                reducer: {
                    return HomeFeature { logger in
                        ClLogger.message(
                            level: .debug,
                            message: logger
                        )
                    }
                })
        )
        
        let hostingController = UIHostingController(
            rootView: homeView)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
