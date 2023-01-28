//
//  MainCoordinatorInterface.swift
//  MainFeed
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import Foundation

public protocol MainCoordinatorInterface: AnyObject {
    
    func showSettingAddress()
    
    func showUserProfile()
    
    func showUserPost()

    func showWeatherInfo()
    
    func showWelcomeSheet()
    
}
