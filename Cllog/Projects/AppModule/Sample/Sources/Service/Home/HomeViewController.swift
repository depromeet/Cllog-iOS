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

        
        // 테스트 네트워크
        Task {
            do {
                let response: Model = try await Starlink.session.request("https://api.github.com/repos/octocat/Spoon-Knife/issues?per_page=2", method: .get).reponseAsync()
            } catch {
                print("asdfsdf")
            }
        }
        
    }
}

struct Model: Decodable {
    let test: String
}
