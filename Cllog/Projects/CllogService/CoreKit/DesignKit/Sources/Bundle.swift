//
//  Bundle.swift
//  ClLogUI
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

private class __Bundle {}

public extension Bundle {
    static var clLogUIBundle: Bundle = Bundle(for: __Bundle.self)
}
