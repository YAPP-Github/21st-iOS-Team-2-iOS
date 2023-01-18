//
//  LocationManager.swift
//  Core
//
//  Created by Ari on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import CoreLocation
import Combine
import Common

public final class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    
    private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        return manager
    }()
    
    private var locationPublisher = CurrentValueSubject<CLLocation?, Never>(nil)
    private var authorizationPublisher = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    private(set) var lastLocation: CLLocation?
    
    public override init() {
        super.init()
        self.manager.delegate = self
    }
    
    public func currentLocation() -> AnyPublisher<CLLocation, Never> {
        guard locationPublisher.value == nil else {
            return Empty().eraseToAnyPublisher()
        }
        manager.startUpdatingLocation()
        return locationPublisher
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    public func authorizationStatus() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return authorizationPublisher.eraseToAnyPublisher()
    }
    
    public func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined, .restricted:
            manager.requestWhenInUseAuthorization()
        default:
            locationPublisher.send(nil)
        }
        authorizationPublisher.send(status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else {
            return
        }
        
        if last.coordinate != lastLocation?.coordinate {
            locationPublisher.send(last)
            lastLocation = last
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            return
        }
        switch error.code {
        case .denied:
            lastLocation = nil
        case .locationUnknown:
            lastLocation = nil
        default:
            lastLocation = nil
        }
    }
    
}
