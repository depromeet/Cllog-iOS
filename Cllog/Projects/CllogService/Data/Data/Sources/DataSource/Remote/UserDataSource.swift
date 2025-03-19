//
//  UserDataSource.swift
//  Data
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import Starlink

public protocol UserDataSource {
    func leave() async throws
    func logout() async throws
}

public final class DefaultUserDataSource: UserDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func leave() async throws {
        let response: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.leave
        )
    }
    
    public func logout() async throws {
        let response: BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.logout
        )
    }
}

enum UserTarget {
    case leave
    case logout
}

extension UserTarget: EndpointType {
    var baseURL: String {
        return "https://dev-api.climb-log.my/api/v1/user"
    }
    
    var path: String {
        switch self {
        case .leave: "/leave"
        case .logout: "/log-out"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .leave: .delete
        case .logout: .post
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .leave, .logout: .none
        }
    }
    
    var encodable: Encodable? {
        nil
    }
    
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
}
