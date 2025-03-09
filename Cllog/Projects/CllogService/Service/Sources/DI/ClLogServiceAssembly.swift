//
//  ClLogServiceAssembly.swift
//  CllogService
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Data
import Domain
import LoginDomain
import FolderDomain
import Networker
import Swinject

public struct ClLogServiceAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(LoginUseCase.self) { _ in
            DefaultLoginUseCase(
                loginRepository: DefaultLoginRepository(
                    authDataSource: DefaultAuthDataSource(
                        provider: UnAuthProvider()
                    ),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
        }
        container.register(MonthLimitUseCase.self) { _ in
            MonthLimit()
        }
        
        container.register(FolderListUseCase.self) { _ in
            MockFolderListUseCase(folderRepository: MockFolderRepository())
        }
    }
}
