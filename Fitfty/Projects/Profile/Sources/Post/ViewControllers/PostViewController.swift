//
//  PostViewController.swift
//  Profile
//
//  Created by 임영선 on 2022/12/15.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common
import Core
import Combine
import Kingfisher

final public class PostViewController: UIViewController {

    private var coordinator: PostCoordinatorInterface
    private var cancellables: Set<AnyCancellable> = .init()
    private var viewModel: PostViewModel
    private var boardToken: String
    private var filepath: String?
    
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
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white.withAlphaComponent(0.2), alpha: 1)
        loadingView.stopAnimating()
        return loadingView
    }()
    
    private var profileType: ProfileType
    private var presentType: ProfilePresentType
    private var nickname: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        viewModel.input.viewWillAppear(boardToken: boardToken)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideNavigationBar()
    }
    
    public init(
        coordinator: PostCoordinatorInterface,
        profileType: ProfileType,
        presentType: ProfilePresentType,
        viewModel: PostViewModel,
        boardToken: String
    ) {
        self.coordinator = coordinator
        self.profileType = profileType
        self.presentType = presentType
        self.viewModel = viewModel
        self.boardToken = boardToken
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coordinator.finishedTapGesture()
    }
    
    private func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .update(let response):
                    self?.update(response)
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                case .errorMessage(let message):
                    self?.showAlert(message: message)
                case .isLoading(let isLoading):
                    isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
                }
            }).store(in: &cancellables)
    }
    
    private func update(_ response: PostResponse) {
        guard let data = response.data,
              let weather = data.tagGroupInfo.weather.stringToWeatherTag else {
            return
        }
        postView.setUp(
            content: data.content ?? "",
            hits: String(data.views).insertComma,
            bookmark: String(data.bookmarkCnt).insertComma,
            date: data.createdAt.yymmddFromCreatedDate,
            weather: weather,
            filepath: data.filePath,
            isBookmarked: data.bookmarked
        )
        miniProfileView.setUp(
            filepath: data.profilePictureUrl,
            nickname: data.nickname
        )
        self.nickname = data.nickname
        self.filepath = data.filePath
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        switch presentType {
        case .tabProfile:
            navigationController?.navigationBar.isHidden = false
        case .mainProfile:
            break
        }
        
        navigationController?.navigationItem.setCustomRightBarButton(
            self,
            action: #selector(didTapRightBarButton),
            image: CommonAsset.Images.btnMoreVertical.image,
            size: 24
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let cancelButton = UIBarButtonItem(
                image: CommonAsset.Images.btnArrowleft.image,
                style: .plain,
                target: self,
                action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    private func hideNavigationBar() {
        switch presentType {
        case .tabProfile:
            navigationController?.navigationBar.isHidden = true
        case .mainProfile:
            break
        }
    }
    
    private func setUpConstraintLayout() {
        view.addSubviews(miniProfileView, scrollView, loadingIndicatorView)
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
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            loadingIndicatorView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            loadingIndicatorView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            loadingIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    @objc private func didTapRightBarButton(_ sender: Any) {
        guard let filepath = filepath else {
            return
        }
        switch profileType {
        case .myProfile:
            coordinator.showBottomSheet(boardToken: boardToken, filepath: filepath)
        case .userProfile:
            coordinator.showReport()
        }
        
    }
    
    @objc private func didTapMiniProfile(_ sender: Any) {
        guard let nickname = nickname else {
            return
        }
        coordinator.showProfile(profileType: .myProfile, nickname: nickname)
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.finished()
    }
    
}
