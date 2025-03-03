//
//  KeychainItemType.swift
//  Data
//
//  Created by soi on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

enum KeychainItemType: RawRepresentable, CaseIterable {
    typealias RawValue = CFString

    case generic
    case password
    case certificate
    case cryptography
    case identity

    init?(rawValue: CFString) {
        switch rawValue {
        case kSecClassGenericPassword:
            self = .generic
        case kSecClassInternetPassword:
            self = .password
        case kSecClassCertificate:
            self = .certificate
        case kSecClassKey:
            self = .cryptography
        case kSecClassIdentity:
            self = .identity
        default:
            return nil
        }
    }

    var rawValue: CFString {
        switch self {
        case .generic:
            return kSecClassGenericPassword
        case .password:
            return kSecClassInternetPassword
        case .certificate:
            return kSecClassCertificate
        case .cryptography:
            return kSecClassKey
        case .identity:
            return kSecClassIdentity
        }
    }
}
