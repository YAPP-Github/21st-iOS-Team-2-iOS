//
//  PostCoordinatorInterface.swift
//  Profile
//
//  Created by 임영선 on 2023/01/30.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public protocol PostCoordinatorInterface: AnyObject {
    
    func showProfile()
    func showBottomSheet()
    func showUploadCody()
    func dismiss()
    func popToRoot()
    func finished()
}
