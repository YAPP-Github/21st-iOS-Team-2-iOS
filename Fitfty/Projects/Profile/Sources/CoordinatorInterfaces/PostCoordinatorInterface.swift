//
//  PostCoordinatorInterface.swift
//  Profile
//
//  Created by 임영선 on 2023/01/30.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public protocol PostCoordinatorInterface: AnyObject {
    
    func showProfile(profileType: ProfileType)
    func showBottomSheet()
    func showUploadCody()
    func dismiss()
    func popToRoot()
    func finished()
    func finishedTapGesture()
}
