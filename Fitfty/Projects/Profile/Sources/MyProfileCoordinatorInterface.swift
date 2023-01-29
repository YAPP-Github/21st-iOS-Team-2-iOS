//
//  ProfileCoordinatorInterface.swift
//  Profile
//
//  Created by 임영선 on 2022/12/15.
//  Copyright © 2022 Fitfty. All rights reserved.
//

public protocol MyProfileCoordinatorInterface: AnyObject {
    
    func showPost()
    func showBottomSheet()
    func showUploadCody()
    func dismiss()
    func popToRoot()
}
