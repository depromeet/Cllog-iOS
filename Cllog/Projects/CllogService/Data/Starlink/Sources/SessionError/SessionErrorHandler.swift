//
//  SessionErrorHandler.swift
//  Starlink
//
//  Created by saeng lin on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

extension Starlink {

    static func sessionErrorHandler(
        _ error: Error
    ) async -> StarlinkError {

        let starlinkError = StarlinkError(error: error)

        let errorInfo = starlinkError.errorInfo

        switch errorInfo?.message?.code {
        case "C4010":
            if let errorInfoMessage = errorInfo?.message {
                NotificationCenter.default.post(
                    name: .didKickOut,
                    object: nil,
                    userInfo: ["ErrorInfoMessage": errorInfoMessage]
                )
            }
            break
        default:
            break
        }

        return starlinkError
    }
}

extension Notification.Name {
    public static let didKickOut = Notification.Name("didKickOut")
}
