//
//  SettingCoordinatorInterface.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common

public protocol SettingCoordinatorInterface: AnyObject {
    func showProfileSetting()
    func showFeedSetting()
    func showMyInfoSetting()
    func showTermsOfUse()
    func showPrivacyRule()
    func showReportList(reportType: ReportType)
    func finished()
}
