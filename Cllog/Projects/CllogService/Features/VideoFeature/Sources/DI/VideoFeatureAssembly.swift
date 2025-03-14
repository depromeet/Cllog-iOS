//
//  VideoFeatureAssembly.swift
//  CaptureFeature
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Swinject

import Domain
import VideoDomain

public struct VideoFeatureAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Swinject.Container) {

        container.register(VideoPermissionUseCase.self) { _ in
            VideoPermission()
        }
        
        container.register(ClLogSessionViewModelInterface.self) { _ in
            ClLogSessionViewModel()
        }
        
        container.register(VideoUseCase.self) { resolver in
            
            guard let videospository = resolver.resolve(VideoRepository.self) else {
                fatalError("Could not resolve CaptureRepository")
            }
            
            return VideoUploadUsesCase(
                videoRepository: videospository
            )
        }
        
        container.register(VideoFeature.self) { resolver in
            return VideoFeature()
        }
        
        container.register(RecordFeature.self) { resolver in
            guard let logConsoleUseCase  = resolver.resolve(LogConsoleUseCase.self) else {
                fatalError("Could not resolve LogConsoleUseCase")
            }
            guard let viewModel = resolver.resolve(ClLogSessionViewModelInterface.self) else {
                fatalError("Could not resolve ClLogSessionViewModelInterface")
            }
            guard let videoUseCase = resolver.resolve(VideoUseCase.self) else {
                fatalError("Could not resolve CaptureUseCase")
            }
            return RecordFeature(
                videoUseCase: videoUseCase,
                sessionViewModel: viewModel,
                logConsoleUsecase: logConsoleUseCase
            )
        }
    }
    
}
