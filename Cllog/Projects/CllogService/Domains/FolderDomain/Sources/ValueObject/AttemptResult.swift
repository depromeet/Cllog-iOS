//
//  AttemptResult.swift
//  FolderDomain
//
//  Created by soi on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public enum AttemptResult: String {
    case complete = "SUCCESS"
    case fail = "FAILURE"
    
    func toggleResult() -> AttemptResult {
        switch self {
        case .complete: .fail
        case .fail:     .complete
        }
    }
}

