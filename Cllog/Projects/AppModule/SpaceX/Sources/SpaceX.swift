//
//  SpaceX.swift
//  SpaceXTests
//
//  Created by saeng lin on 1/27/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

import Alamofire

extension SpaceX {
    
    // default
    public static let session: SpaceX = .init(configure: SpaceX.default())
        .option([
            SpaceXLogTraking()
        ])    
}

public final class SpaceX: Sendable {
    
    private let session: URLSession
    private let trackers: SafeTrackers = .init()
    
    /// 초기화
    /// - Parameter configure: SpaceXConfiguration ( URLSession Configure - Service 별로 주입 필요)
    public init(
        configure: SpaceXConfiguration = SpaceX.default()
    ) {
        self.session = URLSession(
            configuration: configure.configure(),
            delegate: configure.delegate,
            delegateQueue: configure.queue
        )
    }
    
    /// 네트워크 중간에 tracking을 하기 위해서 추가
    /// - Parameter trackers: 트랙킹 구현체 리스트
    /// - Returns: 트랙킹이 추가 된 네트워크 객체
    public func option(
        _ trackers: [any SpaceXTracking]
    ) -> SpaceX {
        self.trackers.append(trackers)
        return self
    }
    
    /// SpaceX.Request ( URL Session을 요청하는 Request 생성 )
    /// - Parameters:
    ///   - urlConversion: URL 포맷
    ///   - params: 파라미터
    ///   - method: 메소드
    ///   - tracking: 로그 Tracker
    /// - Returns: SpaceXRequest
    public func request(
        _ urlConversion: URLConversion,
        params: SafeDictionary<String, Any>? = nil,
        method: SpaceX.Method
    ) -> SpaceXRequest {
        let request = SpaceX.Request(
            session: session,
            path: urlConversion,
            params: params,
            method: method,
            trakers: trackers
        )
        return request
    }
}
