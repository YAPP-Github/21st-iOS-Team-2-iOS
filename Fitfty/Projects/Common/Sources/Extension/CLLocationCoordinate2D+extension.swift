//
//  CLLocationCoordinate2D+extension.swift
//  Common
//
//  Created by Ari on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
