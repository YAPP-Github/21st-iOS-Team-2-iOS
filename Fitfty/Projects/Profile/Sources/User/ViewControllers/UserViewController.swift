//
//  UserViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class UserViewController: UIViewController {

    let coordinator: UserCoordinatorInterface
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    public init(coordinator: UserCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem =
        UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain, target: self,
            action: #selector(didTapBackButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            image: CommonAsset.Images.btnMoreVertical.image,
            style: .plain,
            target: self,
            action: #selector(didTapMoreVerticalButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func didTapBackButton(_ sender: Any?) {
        coordinator.dismiss(self)
    }
    
    @objc func didTapMoreVerticalButton(_ sender: Any?) {
        print("didTapMoreVerticalButton")
    }
}
