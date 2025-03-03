//
//  ClLogApp.swift
//  Cllog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

import DesignKit
import LoginFeature
import CllogService

@main
class ClLogApp {
    
    static func main() {
        
        // Phase 세팅
        ClLogPhase.main()
        
        // DI 세팅
        ClLogDI.register(assemblies: [
            ClLogFont(),
            ClLogServiceAssembly(),
        ])
        
        // App Start
        AppDelegate.main()
    }
}
