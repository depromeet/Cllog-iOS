//
//  Bundle.swift
//  DesignKit
//
//  Created by saeng lin on 2/9/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

private class __Bundle {}

public extension Bundle {
    static var dpUIBundle: Bundle = Bundle(for: __Bundle.self)
}
