//
//  PostViewController.swift
//  Profile
//
//  Created by 임영선 on 2022/12/15.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class MyPostViewController: UIViewController {

    private var coordinator: MyProfileCoordinatorInterface
    private let postView = PostView()
    private let miniProfileView = MiniProfileView(imageSize: 32, frame: .zero)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        postView.setUp(content: "오늘 날씨 너무 좋앗따~~~ 새로 산 원피스 입고!", hits: "51254", bookmark: "312", date: "22.08.15")
        miniProfileView.setUp(image: CommonAsset.Images.profileSample.image, nickname: "iosLover")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomNavigationItem()
    }
    
    public init(coordinator: MyProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
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
        view.addSubviews(postView, miniProfileView)
        NSLayoutConstraint.activate([
            miniProfileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            miniProfileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            miniProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            miniProfileView.heightAnchor.constraint(equalToConstant: 48),
            
            postView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            postView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            postView.topAnchor.constraint(equalTo: miniProfileView.bottomAnchor),
            postView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapRightBarButton(_ sender: Any) {
        coordinator.showBottomSheet()
    }
    
}
