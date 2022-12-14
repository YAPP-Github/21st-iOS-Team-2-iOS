//
//  AuthCoordinatorInterface.swift
//  Auth
//
//  Created by Watcha-Ethan on 2022/12/03.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation

public protocol AuthCoordinatorInterface: AnyObject {
    func pushMainFeedView()
    func pushOnboardingView()
    func presentKakaoLoginView()
}
