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
    
    private var _location = CurrentValueSubject<CLLocation?, Never>(nil)
    private var _authorizationStatus = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    
    public override init() {
        super.init()
        self.manager.delegate = self
    }
    
    public func currentLocation() -> AnyPublisher<CLLocation?, Never> {
        guard _location.value == nil else {
            return Empty().eraseToAnyPublisher()
        }
        manager.startUpdatingLocation()
        return _location
            .eraseToAnyPublisher()
    }
    
    public func authorizationStatus() -> AnyPublisher<CLAuthorizationStatus, Never> {
        return _authorizationStatus.eraseToAnyPublisher()
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
            _location.send(CLLocation(latitude: 37.5663174209601, longitude: 126.977829174031))
        }
        _authorizationStatus.send(status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else {
            return
        }
        
        if last.coordinate != _location.value?.coordinate {
            _location.send(last)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.debug(error: error, message: "위치 가져오기 오류")
    }
    
}
