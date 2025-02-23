//
//  ClLogApp.swift
//  Cllog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

import Starlink

@main
class ClLogApp {
    
    static func main() {
        
        ClLogPhase.main()
        
        // DI 세팅
        
        ConsoleWindow.shared.message(
            label: "[\(Self.self)]\(#function)",
            level: .info,
            message: "[\(Self.self)][Phase] => \(ClLogPhase.current)")
        
        AppDelegate.main()
    }
}
