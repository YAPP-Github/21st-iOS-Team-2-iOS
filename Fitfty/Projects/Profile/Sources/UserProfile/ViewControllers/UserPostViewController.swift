//
//  UserPostViewController.swift
//  Profile
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class UserPostViewController: UIViewController {

    private var coordinator: UserProfileCoordinatorInterface
    private let postView = PostView()
    
    private lazy var miniProfileView: MiniProfileView = {
        let view = MiniProfileView(imageSize: 32, frame: .zero)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMiniProfileView)))
        return view
    }()
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        setConstraintLayout()
        postView.setUp(content: "오늘 날씨 너무 좋앗따~~~ 새로 산 원피스 입고!", hits: "51254", bookmark: "312", date: "22.08.15")
        miniProfileView.setUp(image: CommonAsset.Images.profileSample.image, nickname: "iosLover")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    public init(coordinator: UserProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setConstraintLayout() {
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
    
    @objc func didTapMiniProfileView(_ sender: Any?) {
        coordinator.showProfile()
    }
}
