//
//  AppAppearance.swift
//  Common
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public final class AppAppearance {
    public static func setUpAppearance() {
        UIBarButtonItem.appearance().tintColor = .label
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.label]
    }
}
