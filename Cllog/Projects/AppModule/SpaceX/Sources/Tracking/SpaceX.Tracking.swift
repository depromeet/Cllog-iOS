//
//  SpaceX.Tracking.swift
//  SpaceXTests
//
//  Created by saeng lin on 1/27/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

public protocol SpaceXTracking: Sendable {
    func didRequest(_ request: SpaceX.Request)
    func willRequest(_ request: SpaceX.Request, _ response: SpaceX.Response)
}

public struct SpaceXLogTraking: SpaceXTracking {
    
    /// 로그 요청
    /// - Parameter request: 요청 정보
    public func didRequest(_ request: SpaceX.Request) {
        #if DEBUG
        var log: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let formattedDate = formatter.string(from: request.requestTime)

        log += "👉 [\(request.path)]\n[요청시간] \(formattedDate)"
        var paramsLog = "\n📄 params\n{"
        request.params?.forEach({ key, value in
            paramsLog += "\n    \(key): \(value),"
        })

        paramsLog += "\n}"

        log += paramsLog
        print(log)
        #endif
    }
    
    /// 로그 응답
    /// - Parameters:
    ///   - request: 요청 정보
    ///   - response: 응답 정보
    public func willRequest(_ request: SpaceX.Request, _ response: SpaceX.Response) {
        #if DEBUG
        var log: String = ""
        let statusCode = (response.response as? HTTPURLResponse)?.statusCode ?? -999
        switch statusCode {
        case 200 ..< 300:
            log += "🟢"
        default:
            log += "🔴"
        }

        log += "[\(statusCode)]"

        let timeInterval = response.responseTime.timeIntervalSince(request.requestTime)
        let milliseconds = String(format: "%.2fms", timeInterval * 1000)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let formattedDate = formatter.string(from: response.responseTime)

        log += "[\(request.path)]\n[응답시간][\(milliseconds)] \(formattedDate)"

        if let data = response.data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                log += "\n📄 Response Data:\n\(jsonString)"
            }
        } else if let error = response.error {
            log += "\n📄 Response ERROR:\n\(error)"
        }

        print(log)
        #endif
    }
    
    
}
