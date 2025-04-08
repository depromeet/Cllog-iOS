//
//  LocationFetcher.swift
//  Domain
//
//  Created by soi on 4/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CoreLocation

public protocol LocationFetcher {
    func fetchCurrentLocation() async throws -> CLLocation
}
