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
    
    public enum Constant {
        public static let defaultLongitude = 126.977829174031
        public static let defaultLatitude = 37.5663174209601
        
    }
    
    public static let shared = LocationManager()
    public var currentAuthorizationStatus: CLAuthorizationStatus { manager.authorizationStatus }
    
    private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 100
        return manager
    }()
    
    private var _location = CurrentValueSubject<CLLocation?, Never>(nil)
    
    public override init() {
        super.init()
        self.manager.delegate = self
    }
    
    public func currentLocation() -> AnyPublisher<CLLocation?, Never> {
        guard _location.value == nil else {
            return Empty().eraseToAnyPublisher()
        }
        requestWhenInUseAuthorization()
        requestLocation()
        return _location
            .eraseToAnyPublisher()
    }
    
    public func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    public func requestLocation() {
        manager.requestLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard _location.value == nil ||
                (
                    _location.value?.coordinate.longitude == Constant.defaultLongitude &&
                    _location.value?.coordinate.latitude == Constant.defaultLatitude
                )
        else {
            return
        }
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        case .notDetermined, .restricted:
            requestWhenInUseAuthorization()
        default:
            _location.send(CLLocation(latitude: Constant.defaultLatitude, longitude: Constant.defaultLongitude))
        }
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
