//
//  LoginDataSource.swift
//  Data
//
//  Created by soi on 2/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Networker
import SpaceX // 임시

public protocol LoginDataSource {
    func login() async throws
}

struct DefaultLoginDataSource: LoginDataSource {
    private let spaceX = SpaceX()
    
    func login() async throws {
        guard let url = URL(string: "https://service") else { return }
        // TODO: Networker를 통해 request
        spaceX.request(
            url,
            params: ["test": 1],
            method: .get
        )
    }

}

// TODO: Target으로 url, path, header 등 정의
