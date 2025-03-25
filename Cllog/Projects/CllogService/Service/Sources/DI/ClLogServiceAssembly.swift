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
import ReportDomain

public struct ClLogServiceAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        container.register(LoginUseCase.self) { _ in
            DefaultLoginUseCase(
                repository: DefaultLoginRepository(
                    authDataSource: DefaultAuthDataSource(
                        provider: UnAuthProvider()
                    ),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
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
        
        container.register(FilteredAttemptsUseCase.self) { _ in
            DefaultFilteredAttemptsUseCase(
                attemptRepository: DefaultAttemptRepository(
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
        
        container.register(LogoutUseCase.self) { _ in
            Logout(
                repository: DefaultLogoutRepository(
                    userDataSource: DefaultUserDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    ),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(WithdrawUseCase.self) { _ in
            Withdraw(
                repository: DefaultWithdrawRepository(
                    userDataSource: DefaultUserDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    ),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(LoginTypeFetcherUseCase.self) { _ in
            LoginTypeFetcher(
                repository: DefaultTokenRepository()
            )
        }
        
        container.register(ValidateUserSessionUseCase.self) { _ in
            ValidateUserSession(
                repository: DefaultTokenRepository()
            )
        }
        
        container.register(AttemptUseCase.self) { _ in
            DefaultAttemptUseCase(
                attemptRepository: DefaultAttemptRepository(
                    dataSource: DefaultAttemptDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(EditMemoUseCase.self) { _ in
            EditMemo(
                repository: DefaultEditMemoRepository(
                    dataSource: DefaultStoriesDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(DeleteStoryUseCase.self) { _ in
            DeleteStory(
                repository: DefaultDeleteStoryRepository(
                    dataSource: DefaultStoriesDataSource(
                        provider: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
        
        container.register(ReportFetcherUseCase.self) { _ in
            ReportFetcher(
                repository: DefaultReportRepository(
                    dataSource: DefaultReportDataSource(
                        with: AuthProvider(
                            tokenProvider: DefaultTokenDataSource().loadToken
                        )
                    )
                )
            )
        }
                    
        container.register(VideoRepository.self) { resolver in
            VideoRecordRepositry(
                dataSource: VideoDataSource(
                    videoProvider: UploadProvider(tokenProvider: DefaultTokenDataSource().loadToken),
                    authProvider: AuthProvider(tokenProvider: DefaultTokenDataSource().loadToken)
                )
            )
        }
    }
}
