//
//  ClLogApp.swift
//  Cllog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

import DesignKit

import MainFeature
import LoginFeature
import CllogService
import VideoFeature
import Shared

@main
class ClLogApp {
    
    static func main() {
        
        // Phase 세팅
        ClLogPhase.main()
        
        // DI 세팅
        ClLogDI.register(assemblies: [
            ClLogger(),
            ClLogFont(),
            
            //
            ClLogServiceAssembly(),
            
            // Feature
            HomeFeatureAssembly(),
            MainFeatureAssembly(),
            VideoFeatureAssembly(),
            
            AppVersionCheckAssembly()
        ])
        
        // App Start
        AppDelegate.main()
    }
}
