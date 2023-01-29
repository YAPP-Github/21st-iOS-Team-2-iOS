//
//  IntroViewController.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

final public class IntroViewController: UIViewController {
    private let coordinator: IntroCoordinatorInterface
    
    private let titleLabel = UILabel()
    private let introImageView = UIImageView()
    private let nextButton = FitftyButton(style: .enabled, title: "계속하기")
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(coordinator: IntroCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    private func configure() {
        configureTitleLabel()
        configureIntroImageView()
        configureNextButton()
    }
    
    private func configureTitleLabel() {
        view.addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 27),
            titleLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = "추운데 뭐 입을까?\n더 이상 고민고민하지마"
        titleLabel.textColor = CommonAsset.Colors.gray08.color
        titleLabel.font = FitftyFont.appleSDRegular(size: 32).font
    }
    
    private func configureIntroImageView() {
        view.addSubviews(introImageView)
        NSLayoutConstraint.activate([
        
        ])
    }
    
    private func configureNextButton() {
        
    }
}
