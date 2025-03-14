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
        // 준영
//        container.register(MonthLimitUseCase.self) { _ in
//            MonthLimit()
//        }
        
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
        
        // 준영
//        container.register(FolderUseCase.self) { _ in
//            
//            DefaultFolderListUseCase(
//                attemptUseCase: MockAttemptUseCase(attemptRepository: MockAttemptRepository()),
//                gradeUseCase: MockGradeUseCase(gradeRepository: MockGradeRepository()),
//                cragUseCase: MockCragUseCase(cragRepository: MockCragRepository())
//            )
//        }
    }
}
