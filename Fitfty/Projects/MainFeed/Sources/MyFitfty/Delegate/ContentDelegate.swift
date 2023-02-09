//
//  ContentDelegate.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/09.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

protocol ContentDelegate: AnyObject {
    func sendContent(text: String)
}
