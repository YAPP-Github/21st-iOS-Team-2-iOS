//
//  FeedSettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class FeedSettingViewController: UIViewController {
    
    private weak var coordinator: FeedSettingCoordinatorInterface?
    private var viewModel: FeedSettingViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: FeedSettingCoordinatorInterface, viewModel: FeedSettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator?.dismiss()
    }
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "핏프티 피드 정보 설정", isChevronButtonHidden: true)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
}

private extension FeedSettingViewController {
    
    func setUp() {
        setUpLayout()
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(navigationBarView)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
    
    @objc func didTapCancelButton(_ sender: UITapGestureRecognizer) {
        coordinator?.dismiss()
    }
    
}
