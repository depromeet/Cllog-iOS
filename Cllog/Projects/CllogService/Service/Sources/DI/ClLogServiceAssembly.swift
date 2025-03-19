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
import AccountDomain
import FolderDomain
import CalendarDomain
import VideoDomain
import StoryDomain
import Networker
import Swinject
import AccountDomain

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
        
        container.register(GradeUseCase.self) { _ in
            DefaultGradeUseCase(
                repository: DefaultGradeRepository(
                    dataSource: DefaultGradeDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(CragUseCase.self) { _ in
            DefaultCragUseCase(
                repository: DefaultCragRepository(
                    dataSource: DefaulCragDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
    }
}
