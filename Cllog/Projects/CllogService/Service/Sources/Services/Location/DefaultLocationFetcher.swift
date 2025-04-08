//
//  DefaultLocationFetcher.swift
//  CllogService
//
//  Created by soi on 4/8/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CoreLocation
import Domain

public final class DefaultLocationFetcher: NSObject, LocationFetcher {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    
    public override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    public func fetchCurrentLocation() async throws -> CLLocation {
        locationContinuation?.resume(throwing: LocationError.failedToFetch)
        locationContinuation = nil
        
        let status = locationManager.authorizationStatus
        
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw LocationError.noPermission
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.startUpdatingLocation()
            
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000)
                guard locationContinuation != nil else { return }
                let currentContinuation = locationContinuation
                locationContinuation = nil
                currentContinuation?.resume(throwing: LocationError.failedToFetch)
            }
        }
    }
}

extension DefaultLocationFetcher: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        
        guard let recentLocation = locations.last else {
            return continuation.resume(throwing: LocationError.failedToFetch)
        }
        
        return continuation.resume(returning: recentLocation)
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        continuation.resume(throwing: error)
    }
}
