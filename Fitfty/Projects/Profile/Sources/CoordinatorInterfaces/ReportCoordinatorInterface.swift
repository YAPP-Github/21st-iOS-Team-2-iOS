//
//  ReportCoordinatorInterface.swift
//  Profile
//
//  Created by 임영선 on 2023/02/14.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public protocol ReportCoordinatorInterface: AnyObject {
    
    func showDetailReport(_ reportType: ReportType, userToken: String?, boardToken: String?)
    func dismiss()
    func popToRoot()
    
}
