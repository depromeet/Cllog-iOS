//
//  LocationPermissionUseCase.swift
//  Domain
//
//  Created by soi on 4/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import CoreLocation

public final class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func requestPermission() async throws -> CLLocation {
        let currentStatus = CLLocationManager().authorizationStatus
        
        switch currentStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return try await getCurrentLocation()
        case .denied, .restricted:
            throw NSError(domain: "LocationPermission", code: 1, userInfo: [NSLocalizedDescriptionKey: "Location permission denied."])
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return try await getCurrentLocation()
        @unknown default:
            throw NSError(domain: "LocationPermission", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown location permission status."])
        }
    }
    
    private func getCurrentLocation() async throws -> CLLocation {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            continuation?.resume(throwing: NSError(domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "No location data found."]))
            return
        }
        continuation?.resume(returning: location)
        continuation = nil // continuation을 더 이상 사용하지 않도록 nil로 설정
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil // continuation을 더 이상 사용하지 않도록 nil로 설정
    }
}
