//
//  WelcomeViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public class WelcomeViewController: UIViewController {

    private weak var coordinator: WelcomeCoordinatorInterface?
    private var viewModel: WelcomeViewModel
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: WelcomeCoordinatorInterface, viewModel: WelcomeViewModel) {
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
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.weather.image
        imageView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    private lazy var labelsView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: 12)
        stackView.addArrangedSubviews(welcomeLabel, descriptionLabel)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: .zero,
            leading: 20,
            bottom: .zero,
            trailing: 20
        )
        return stackView
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "User님 안녕하세요?\n핏프티에 오신걸 환영해요."
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 2
        label.setTextWithLineHeight(text: label.text, lineHeight: 32)
        label.font = FitftyFont.appleSDBold(size: 24).font
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "핏프티에서 날씨에 어울리는 코디 추천을 받아보세요."
        label.textAlignment = .left
        label.textColor = CommonAsset.Colors.gray05.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        return label
    }()
    
    private lazy var startButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "시작하기")
        button.addTarget(self, action: #selector(didTapStartButton(_:)), for: .touchUpInside)
        return button
    }()
}

private extension WelcomeViewController {
    
    func setUp() {
        setUpBackgroundView()
        setUpLayout()
    }
    
    func setUpBackgroundView() {
        view.backgroundColor = .white
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: view.safeAreaLayoutGuide.layoutFrame.width, height: 250)
        gradientLayer.colors = [CommonAsset.Colors.ft.color.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0.1]
        gradientLayer.cornerRadius = 15
        view.layer.addSublayer(gradientLayer)
    }
    
    func setUpLayout() {
        view.addSubviews(weatherImageView, labelsView, startButton)
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            weatherImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            labelsView.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 78),
            labelsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            labelsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.topAnchor.constraint(equalTo: labelsView.bottomAnchor, constant: 40)
        ])
    }
    
    @objc func didTapStartButton(_ sender: FitftyButton) {
        coordinator?.dismiss()
    }
}
