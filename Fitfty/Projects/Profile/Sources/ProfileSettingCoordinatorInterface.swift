//
//  ProfileSettingCoordinatorInterface.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public protocol ProfileSettingCoordinatorInterface: AnyObject {
    
    func dismiss()
    
    func showImagePicker(_ viewController: UIViewController)
}
