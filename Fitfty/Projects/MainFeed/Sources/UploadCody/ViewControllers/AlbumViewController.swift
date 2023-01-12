//
//  AlbumViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class AlbumViewController: UIViewController {
    
    private let navigationBarView = BarView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setConstraintsLayout()
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: false)
    }

}
