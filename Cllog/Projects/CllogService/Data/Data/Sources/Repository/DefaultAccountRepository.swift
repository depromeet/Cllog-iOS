//
//  DefaultAccountRepository.swift
//  Data
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import AccountDomain

public struct DefaultAccountRepository: AccountRepository {
    private let dataSource: UserDataSource
    
    public init(dataSource: UserDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetchAccount() async throws -> User {
        try await dataSource.me().toDomain()
    }
    
    public func updateName(_ name: String) async throws {
        try await dataSource.name(UserNameRequestDTO(name: name))
    }
}
