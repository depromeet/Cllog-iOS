//
//  ClLogPhase.swift
//  Cllog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

@frozen public enum ClLogPhase: String, Sendable {
    
    case dev = "dev"
    case production = "production"
    
    public var prefix: String {
        switch self {
        case .dev:
            return "dev-"
            
        case .production:
            return ""
        }
    }
    
    private static var _current: ClLogPhase?
    
    public static var current: ClLogPhase {
        get {
            if _current == nil {
                _current = .production
            }
            return _current!
        }
        set {
            _current = newValue
        }
    }
    
    static func main() {
        // otherLink를 추가해서 #if로 구현해도 괜찮음
        #if Dev
        ClLogPhase.current = .dev
        #elseif Prod
        ClLogPhase.current = .production
        #endif
        
        ClLogger.message(
            label: "[\(Self.self)]\(#function)",
            level: .info,
            message: "[\(Self.self)][Phase] => \(ClLogPhase.current)"
        )
    }
}
