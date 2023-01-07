//
//  UploadCodyViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class UploadCodyViewController: UIViewController {
    
    private var coordinator: UploadCodyCoordinatorInterface

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public init(coordinator: UploadCodyCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
