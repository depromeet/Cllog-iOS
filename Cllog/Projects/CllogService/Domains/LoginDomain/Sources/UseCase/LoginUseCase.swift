//
//  LoginUseCase.swift
//  LoginDomain
//
//  Created by soi on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public enum LoginType {
    case apple
    case kakao
}

public enum LoginError: Error {
    case failed
    // Todo
}

public protocol LoginUseCase {
    func login() async throws
}
