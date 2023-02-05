//
//  AlbumListViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class AlbumListViewController: UIViewController {

    private let coordinator: AlbumListCoordinatorInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init(coordinator: AlbumListCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
