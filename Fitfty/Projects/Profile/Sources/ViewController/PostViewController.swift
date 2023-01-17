//
//  PostViewController.swift
//  Profile
//
//  Created by 임영선 on 2022/12/15.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class PostViewController: UIViewController {

    private var coordinator: ProfileCoordinatorInterface
    private let postView = PostView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomNavigationItem()
    }
    
    public init(coordinator: ProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setUpConstraintLayout()
        postView.setUp(content: "오늘 날씨 너무 좋앗따~~~ 새로 산 원피스 입고!", hits: "51254", bookmark: "312", date: "22.08.15")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCustomNavigationItem() {
        navigationController?.navigationItem.setCustomBackButton(self)
        navigationController?.navigationItem.setCustomRightBarButton(
            self,
            action: #selector(didTapRightBarButton),
            image: CommonAsset.Images.btnMoreVertical.image,
            size: 24
        )
    }
    
    private func setUpConstraintLayout() {
        view.addSubviews(postView)
        NSLayoutConstraint.activate([
            postView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            postView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            postView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapRightBarButton(_ sender: Any) {
        print("tappedRightBarButton")
    }
    
}
