//
//  ClLogCaptureViewController.swift
//  ClLogCaptureFeature
//
//  Created by saeng lin on 2/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

extension ClLogCaptureViewController {
    static func start(on: UIViewController) async throws -> ClLogCaptureViewController.ContinuationData {
        
        return try await withCheckedThrowingContinuation { continuation in
            let viewController = ClLogCaptureViewController(continuation: continuation)
            
            let navigationController = UINavigationController(rootViewController: viewController)
            
            on.present(navigationController, animated: true)
        }
    }
}

class ClLogCaptureViewController: UIViewController {
    
    typealias ContinuationData = Void
    
    private var continuation: CheckedContinuation<ClLogCaptureViewController.ContinuationData, any Error>?
    
    init(continuation: CheckedContinuation<ClLogCaptureViewController.ContinuationData, any Error>? = nil) {
        self.continuation = continuation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
