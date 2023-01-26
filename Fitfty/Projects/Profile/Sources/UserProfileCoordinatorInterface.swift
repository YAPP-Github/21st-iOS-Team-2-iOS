//
//  UserCoordinatorInterface.swift
//  Profile
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public protocol UserProfileCoordinatorInterface: AnyObject {
    func showPost()
    func showReport(_ viewController: UIViewController)
    func dismissReport(_ viewController: UIViewController)
    func showProfile()
}
