//
//  GradeDataSource.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink
import Networker

public protocol GradeDataSource {
    func myGrades() async throws -> [FolderGradeResponseDTO]
}

public final class DefaultGradeDataSource: GradeDataSource {
    private let provider: Provider
    
    public init(provider: Provider) {
        self.provider = provider
    }
    
    public func myGrades() async throws -> [FolderGradeResponseDTO] {
        let response: BaseResponseDTO<BaseContentsResponse<[FolderGradeResponseDTO], BaseMetaResponseDTO>> = try await provider.request(
            GradeTarget.myGrades
        )
        
        guard let myGrades = response.data?.contents else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return myGrades
    }
}

enum GradeTarget {
    case myGrades
}

extension GradeTarget: EndpointType {
    var encoding: any StarlinkEncodable {
        Starlink.StarlinkURLEncoding()
    }
    
    var baseURL: String {
        "https://dev-api.climb-log.my"
    }
    
    var path: String {
        switch self {
        case .myGrades: "/api/v1/grades/me"
        }
    }
    
    var method: Starlink.Method {
        switch self {
        case .myGrades: .get
        }
    }
    
    var parameters: Networker.ParameterType? {
        switch self {
        case .myGrades: nil
        }
    }
    
    var encodable: (any Encodable)? {
        switch self {
        case .myGrades: nil
        }
    }
    
    var headers: [Starlink.Header]? {
        switch self {
        case .myGrades: nil
        }
    }
    
    
}
