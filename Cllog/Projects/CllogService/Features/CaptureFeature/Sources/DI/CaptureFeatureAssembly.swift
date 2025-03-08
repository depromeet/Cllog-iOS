//
//  CaptureFeatureAssembly.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Swinject

import Domain
import CaptureDomain
import Data

public struct CaptureFeatureAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Swinject.Container) {
        
        container.register(CaptureRepository.self) { _ in
            CaptureRecordRepositry()
        }
        
        container.register(CapturePermissionUseCase.self) { _ in
            CapturePermission()
        }
        
        container.register(ClLogSessionViewModelInterface.self) { _ in
            ClLogSessionViewModel()
        }
        
        container.register(CaptureUseCase.self) { resolver in
            
            guard let capturerepository = resolver.resolve(CaptureRepository.self) else {
                fatalError("Could not resolve CaptureRepository")
            }
            
            return CaptureUploadUsesCase(
                capturerepository: capturerepository
            )
        }
        
        container.register(CaptureFeature.self) { resolver in
            guard let captureUseCase = resolver.resolve(CaptureUseCase.self) else {
                fatalError("Could not resolve CaptureUseCase")
            }
            
            guard let logConsoleUseCase  = resolver.resolve(LogConsoleUseCase.self) else {
                fatalError("Could not resolve LogConsoleUseCase")
            }
            
            guard let permissionUseCase = resolver.resolve(CapturePermissionUseCase.self) else {
                fatalError("Could not resolve CapturePermissionUseCase")
            }
            
            return CaptureFeature(
                logConsoleUseCase: logConsoleUseCase,
                permissionUseCase: permissionUseCase,
                captureUseCase: captureUseCase
            )
        }
        
        container.register(RecordFeature.self) { resolver in
            guard let logConsoleUseCase  = resolver.resolve(LogConsoleUseCase.self) else {
                fatalError("Could not resolve LogConsoleUseCase")
            }
            guard let viewModel = resolver.resolve(ClLogSessionViewModelInterface.self) else {
                fatalError("Could not resolve ClLogSessionViewModelInterface")
            }
            return RecordFeature(
                sessionViewModel: viewModel,
                logConsoleUsecase: logConsoleUseCase
            )
        }
    }
    
}
