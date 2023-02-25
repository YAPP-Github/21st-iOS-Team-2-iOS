//
//  FitftyLaunchScreenViewController.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine

import Common

final public class FitftyLaunchScreenViewController: UIViewController {
    private let coordinator: FitftyLaunchScreenCoordinatorInterface
    
    private let viewModel: FitftyLaunchScreenViewModel
    private var cancellables = Set<AnyCancellable>()

    private let logoImageView = UIImageView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    public init(viewModel: FitftyLaunchScreenViewModel, coordinator: FitftyLaunchScreenCoordinatorInterface) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
        configureLogoImageView()
        viewModel.checkUserSession()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLogoImageView() {
        view.addSubviews(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            logoImageView.widthAnchor.constraint(equalToConstant: 124),
            logoImageView.heightAnchor.constraint(equalToConstant: 39)
        ])
        
        logoImageView.image = CommonAsset.Images.fitftyLogoImage.image
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .pushAuthView(let needsIntroView):
                    self?.coordinator.pushAuthView(needsIntroView: needsIntroView)
                case .pushMainFeedView:
                    self?.coordinator.pushMainFeedView()
                }
            }
            .store(in: &cancellables)
    }
}
