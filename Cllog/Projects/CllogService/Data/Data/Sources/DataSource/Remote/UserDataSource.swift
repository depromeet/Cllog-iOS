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
    func leave(_ request: AppleWithdrawCodeRequestDTO?) async throws
    func logout() async throws
}

public final class DefaultUserDataSource: UserDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func leave(_ request: AppleWithdrawCodeRequestDTO?) async throws {
        let _ : BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.leave(request)
        )
    }
    
    public func logout() async throws {
        let _ : BaseResponseDTO<EmptyResponseDTO> = try await provider.request(
            UserTarget.logout
        )
    }
}

enum UserTarget {
    case leave(AppleWithdrawCodeRequestDTO?)
    case logout
}

extension UserTarget: EndpointType {
    var baseURL: String {
        return Environment.baseURL + "/api/v1/users"
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
        case .logout:
            return .none
        case .leave(let request):
            if let request {
                return .encodable(request)
            } else {
                return .none
            }
        }
    }
    
    var encodable: Encodable? {
        nil
    }
    
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkJSONEncoding()
    }
    
    var headers: [Starlink.Header]? {
        nil
    }
}
