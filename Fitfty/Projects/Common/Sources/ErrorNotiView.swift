//
//  ErrorNotiView.swift
//  Common
//
//  Created by Ari on 2023/02/06.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public final class ErrorNotiView: UIView {
    
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: -1.0, height: 438)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, description: String) {
        super.init(frame: .zero)
        configure()
        setUp(title: title, description: description)
        
    }
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.weather.image
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 16)
        stackView.addArrangedSubviews(titleLabel, descriptionLabel)
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FitftyFont.appleSDBold(size: 32).font
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray05.color
        label.font = FitftyFont.appleSDSemiBold(size: 15).font
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 16)
        stackView.addArrangedSubviews(backButton, mainButton)
        return stackView
    }()
    
    private lazy var backButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "이전 페이지")
        return button
    }()
    
    private lazy var mainButton: FitftyButton = {
        let button = FitftyButton(style: .disabled, title: "메인 화면으로 이동")
        button.backgroundColor = .white
        return button
    }()
    
    public func setBackButtonTarget(target: Any?, action: Selector) {
        backButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func setMainButtonTarget(target: Any?, action: Selector) {
        mainButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func setUp(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
}

private extension ErrorNotiView {
    
    func configure() {
        addSubviews(weatherImageView, backgroundStackView, buttonStackView)
        NSLayoutConstraint.activate([
            weatherImageView.topAnchor.constraint(equalTo: topAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundStackView.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor, constant: 78),
            backgroundStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            backgroundStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            backgroundStackView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20)
        ])
    }
}
