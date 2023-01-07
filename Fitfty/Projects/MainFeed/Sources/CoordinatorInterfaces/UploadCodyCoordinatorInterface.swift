//
//  UploadCodyCoordinatorInterface.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import UIKit

public protocol UploadCodyCoordinatorInterface: AnyObject {
    
    func showAlbum()
    
    func dismissUploadCody(_ viewController: UIViewController)
    
}
