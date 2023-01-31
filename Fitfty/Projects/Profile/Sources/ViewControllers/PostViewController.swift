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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fill,
            spacing: 0
        )
        stackView.addArrangedSubviews(postView)
       return stackView
    }()
    
    private var profileType: ProfileType
    private var presentType: ProfilePresentType
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        postView.setUp(content: """
                        (1,2,3,4)

                        Baby, got me looking so crazy

                        빠져버리는 daydream

                        Got me feeling you

                        너도 말해줄래

                        누가 내게 뭐라든

                        남들과는 달라 넌

                        Maybe you could be the one

                        날 믿어봐 한번

                        I'm not looking for just fun

                        Maybe I could be the one

                        Oh baby
                        예민하대 나 lately

                        너 없이는 매일 매일이 yeah
                        """,
                       hits: "51254",
                       bookmark: "312",
                       date: "22.08.15"
        )
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
    
    public init(coordinator: PostCoordinatorInterface, profileType: ProfileType, presentType: ProfilePresentType) {
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
        navigationController?.navigationBar.prefersLargeTitles = false
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
        view.addSubviews(miniProfileView, scrollView)
       scrollView.addSubviews(stackView)
        NSLayoutConstraint.activate([
            miniProfileView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            miniProfileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            miniProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            miniProfileView.heightAnchor.constraint(equalToConstant: 48),
            
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: miniProfileView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    @objc private func didTapRightBarButton(_ sender: Any) {
        coordinator.showBottomSheet()
    }
    
    @objc private func didTapMiniProfile(_ sender: Any) {
        coordinator.showProfile()
    }
    
}
