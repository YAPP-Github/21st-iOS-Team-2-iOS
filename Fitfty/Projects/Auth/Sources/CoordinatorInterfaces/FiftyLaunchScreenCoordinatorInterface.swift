//
//  FiftyLaunchScreenCoordinatorInterface.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol FitftyLaunchScreenCoordinatorInterface: AnyObject {
    func pushMainFeedView()
    func pushAuthView(needsIntroView: Bool)
}
