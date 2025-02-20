//
//  Starlink.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

extension Starlink {
    
    // default
    public static var session: Starlink {
        let configure = Starlink.default()
        return Starlink(
            session: URLSession(
                configuration: configure.configure(),
                delegate: configure.delegate,
                delegateQueue: configure.queue
            )
        )
        .option([
            StarlinkLogTraking()
        ])
    }
}

public final class Starlink: @unchecked Sendable {
    
    private let session: Sessionable
    private let trackers: SafeTrackers = .init()
    private let interceptors: [any StarlinkInterceptor]
    
    /// 초기화
    /// - Parameter configure: Configuration ( URLSession Configure - Service 별로 주입 필요)
    public init(
        session: Sessionable,
        interceptors: [any StarlinkInterceptor] = []
    ) {
        self.session = session
        self.interceptors = interceptors
    }
    
    /// 네트워크 중간에 tracking을 하기 위해서 추가
    /// - Parameter trackers: 트랙킹 구현체 리스트
    /// - Returns: 트랙킹이 추가 된 네트워크 객체
    public func option(
        _ trackers: [any StarlinkTracking]
    ) -> Starlink {
        self.trackers.append(trackers)
        return self
    }
    
    /// Starlink.Request ( URL Session을 요청하는 Request 생성 )
    /// - Parameters:
    ///   - urlConversion: URL 포맷
    ///   - params: 파라미터
    ///   - method: 메소드
    ///   - tracking: 로그 Tracker
    /// - Returns: Starlink
    public func request(
        _ urlConversion: URLConversion,
        params: SafeDictionary<String, Any>? = nil,
        method: Starlink.Method,
        headers: [Starlink.Header] = []
    ) -> StarlinkRequest {
        let request = Starlink.Request(
            session: session,
            path: urlConversion,
            params: params,
            method: method,
            headers: headers,
            trakers: trackers,
            interceptors: interceptors
        )
        return request
    }
}
