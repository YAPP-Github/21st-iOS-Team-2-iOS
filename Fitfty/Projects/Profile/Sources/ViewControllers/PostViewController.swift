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

    private var coordinator: PostCoordinatorInterface
    private let postView = PostView()
    
    private lazy var miniProfileView: MiniProfileView = {
        let view = MiniProfileView(imageSize: 32, frame: .zero)
        view.setActionMiniProfileView(self, action: #selector(didTapMiniProfile))
        return view
    }()
    
    private var profileType: ProfileType
    private var presentType: PresentType
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        postView.setUp(content: "오늘 날씨 너무 좋앗따~~~ 새로 산 원피스 입고!", hits: "51254", bookmark: "312", date: "22.08.15")
        miniProfileView.setUp(image: CommonAsset.Images.profileSample.image, nickname: "iosLover")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar()
    }
    
    public init(coordinator: PostCoordinatorInterface, profileType: ProfileType, presentType: PresentType) {
        self.coordinator = coordinator
        self.profileType = profileType
        self.presentType = presentType
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        if presentType == .tab {
            navigationController?.navigationBar.isHidden = false
        }
        if profileType == .myProfile {
            navigationController?.navigationItem.setCustomRightBarButton(
                self,
                action: #selector(didTapRightBarButton),
                image: CommonAsset.Images.btnMoreVertical.image,
                size: 24
            )
        }
    }
    
    private func showNavigationBar() {
        if presentType == .tab {
            navigationController?.navigationBar.isHidden = true
        }
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
    
    @objc private func didTapMiniProfile(_ sender: Any) {
        coordinator.showProfile()
    }
    
}
