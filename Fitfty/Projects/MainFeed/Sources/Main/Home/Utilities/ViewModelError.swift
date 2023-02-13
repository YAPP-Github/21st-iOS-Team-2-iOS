//
//  ViewModelError.swift
//  MainFeed
//
//  Created by Ari on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public enum ViewModelError: Error {
    case failure(errorCode: String, message: String)
}
