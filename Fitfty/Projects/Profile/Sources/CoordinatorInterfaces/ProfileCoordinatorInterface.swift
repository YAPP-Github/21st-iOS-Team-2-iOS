//
//  ProfileCoordinatorInterface.swift
//  Profile
//
//  Created by 임영선 on 2022/12/15.
//  Copyright © 2022 Fitfty. All rights reserved.
//

public protocol ProfileCoordinatorInterface: AnyObject {
    
    func showPost(profileType: ProfileType)
    func showReport()
    func showUploadCody()
    func showDetailReport()
    func showSetting()
    func dismiss()
}
