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
import CalendarDomain
import VideoDomain
import StoryDomain
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
        
        container.register(VideoRepository.self) { resolver in
            VideoRecordRepositry(provider: AuthProvider(
                tokenProvider: DefaultTokenDataSource().loadToken
            ))
        }
        
        container.register(FutureMonthCheckerUseCase.self) { _ in
            FutureMonthChecker()
        }
        
        container.register(FetchCalendarUseCase.self) { _ in
            FetchCalendar(
                repository: DefaultCalendarRepository(
                    dataSource: DefaultCalendarDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(FetchStoryUseCase.self) { _ in
            FetchStory(
                repository: DefaultStoryRepository(
                    dataSource: DefaultStoriesDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(AttemptUseCase.self) { _ in
            DefaultAttemptUseCase(
                repository: DefaultAttemptRepository(
                    dataSource: DefaultAttemptDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(FetchFilterableAttemptInfoUseCase.self) { resolver in
            let authProvider = AuthProvider(
                tokenProvider: DefaultTokenDataSource().loadToken
            )
            let gradeRepository = DefaultGradeRepository(
                dataSource: DefaultGradeDataSource(provider: authProvider)
            )
            let cragRepository = DefaultCragRepository(
                dataSource: DefaultCragDataSource(provider: authProvider)
            )
            
            return DefaultFetchFilterableAttemptInfoUseCase(
                gradeRepository: gradeRepository,
                cragRepository: cragRepository
            )
        }
    }
}
