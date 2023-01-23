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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setConstraintLayout()
        postView.setUp(content: "오늘 날씨 너무 좋앗따~~~ 새로 산 원피스 입고!", hits: "51254", bookmark: "312", date: "22.08.15")
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
