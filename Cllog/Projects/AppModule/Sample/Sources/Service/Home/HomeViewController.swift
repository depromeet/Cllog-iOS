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

extension HomeViewController {
    
    static func instance() -> HomeViewController {
        return HomeViewController()
    }
}

final class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clLogUI.background
    }
}
