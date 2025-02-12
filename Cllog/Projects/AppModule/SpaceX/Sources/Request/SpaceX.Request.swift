//
//  SpaceX.Request.swift
//  SpaceXTests
//
//  Created by saeng lin on 1/27/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Combine

public protocol SpaceXRequest {
    
    func reponsePublisher<T: Decodable>() -> AnyPublisher<T, any Error>
    func reponseAsync<T: Decodable>() async throws -> T
    func response<T: Decodable>(_ complete: @escaping @Sendable (Result<T, any Error>) -> Void)
}

extension SpaceX {

    public struct Request: @unchecked Sendable {
        private let id: UUID
        public let session: URLSession
        public let path: URLConversion
        public let params: [String: Any]?
        public let method: Method
        public let requestTime: Date
        let trakers: [any SpaceXTracking]

        /// 초기화
        /// - Parameters:
        ///   - session: URLSession
        ///   - method: REST full Method
        ///   - path: api path
        ///   - requestTime: 요청 시간
        init(
            id: UUID = .init(),
            session: URLSession,
            path: URLConversion,
            params: [String: Any]? = nil,
            method: Method,
            requestTime: Date = Date(),
            trakers: [any SpaceXTracking]
        ) {
            self.id = id
            self.session = session
            self.path = path
            self.params = params
            self.method = method
            self.requestTime = requestTime
            self.trakers = trakers
        }
    }
}

public protocol URLConversion: Sendable {
    func asURL() throws -> URL
}

extension String: URLConversion {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw NSError(domain: "InValid URL", code: -999)
        }
        return url
    }
    
}

extension URL: URLConversion {
    public func asURL() throws -> URL {
        return self
    }
}
