//
//  OnboardingCoordinatorInterface.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol OnboardingCoordinatorInterface: AnyObject {
    func pushNicknameView()
    func pushStyleView()
    func pushMainFeedView()
    
    func pop()
}
