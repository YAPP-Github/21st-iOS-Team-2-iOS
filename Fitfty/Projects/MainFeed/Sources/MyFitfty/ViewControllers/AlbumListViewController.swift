//
//  AlbumListViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class AlbumListViewController: UIViewController {

    private let coordinator: AlbumListCoordinatorInterface
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "최근 항목", isChevronButtonHidden: false)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setcontstratinsLayout()
    }
    
    public init(coordinator: AlbumListCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setcontstratinsLayout() {
        view.addSubviews(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
}
