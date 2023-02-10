//
//  IntroView.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

// TODO: - UI수정해야함
final class AuthIntroView: UIView {
    private let titleLabel = UILabel()
    private let introBackgroundImageView = UIImageView()
    private let introImageView = UIImageView()
    private let temperatureImageView = UIImageView()
    private let temperatureDegreeImageView = UIImageView()
    private let cloudIconImageView = UIImageView()
    private let nextButton = FitftyButton(style: .enabled, title: Style.NextButton.text)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureTitleLabel()
        configureIntroBackgroundImageView()
        configureIntroImageView()
        configureTemperatureImageView()
        configureTemperatureDegreeImageView()
        configureCloudIconImageView()
        configureNextButton()
    }
    
    private func configureTitleLabel() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Style.TitleLabel.margin),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        titleLabel.numberOfLines = Style.TitleLabel.numberOfLines
        titleLabel.text = Style.TitleLabel.text
        titleLabel.textColor = Style.TitleLabel.textColor
        titleLabel.font = Style.TitleLabel.font
        titleLabel.setTextWithLineHeight(lineHeight: Style.TitleLabel.lingHeight)
        titleLabel.textAlignment = Style.TitleLabel.textAlignment
    }
    
    private func configureIntroBackgroundImageView() {
        addSubviews(introBackgroundImageView)
        NSLayoutConstraint.activate([
            introBackgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            introBackgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            introBackgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            introBackgroundImageView.heightAnchor.constraint(lessThanOrEqualToConstant: Style.IntroBackgroundImageView.maxHeight)
        ])
        
        introBackgroundImageView.image = Style.IntroBackgroundImageView.image
        introBackgroundImageView.contentMode = .scaleAspectFill
    }
    
    private func configureIntroImageView() {
        introBackgroundImageView.addSubviews(introImageView)
        NSLayoutConstraint.activate([
            introImageView.topAnchor.constraint(equalTo: introBackgroundImageView.topAnchor),
            introImageView.bottomAnchor.constraint(equalTo: introBackgroundImageView.bottomAnchor),
            introImageView.leadingAnchor.constraint(equalTo: introBackgroundImageView.leadingAnchor, constant: Style.IntroImageView.margin.left),
            introImageView.trailingAnchor.constraint(equalTo: introBackgroundImageView.trailingAnchor, constant: -Style.IntroImageView.margin.right)
        ])
        
        introImageView.image = Style.IntroImageView.image
    }
    
    private func configureTemperatureImageView() {
        introImageView.addSubviews(temperatureImageView)
        NSLayoutConstraint.activate([
            temperatureImageView.leadingAnchor.constraint(equalTo: introImageView.leadingAnchor, constant: Style.TemperatureImageView.margin.left),
            temperatureImageView.bottomAnchor.constraint(equalTo: introImageView.bottomAnchor, constant: -Style.TemperatureImageView.margin.bottom),
            temperatureImageView.heightAnchor.constraint(equalToConstant: Style.TemperatureImageView.size.height),
            temperatureImageView.widthAnchor.constraint(equalToConstant: Style.TemperatureImageView.size.width)
        ])
        
        temperatureImageView.image = Style.TemperatureImageView.image
        temperatureImageView.contentMode = .scaleAspectFit
    }
    
    private func configureTemperatureDegreeImageView() {
        introImageView.addSubviews(temperatureDegreeImageView)
        NSLayoutConstraint.activate([
            temperatureDegreeImageView.leadingAnchor.constraint(equalTo: temperatureImageView.trailingAnchor, constant: Style.TemperatureDegreeImageView.margin.left),
            temperatureDegreeImageView.bottomAnchor.constraint(equalTo: introImageView.bottomAnchor, constant: -Style.TemperatureDegreeImageView.margin.bottom),
            temperatureDegreeImageView.heightAnchor.constraint(equalToConstant: Style.TemperatureDegreeImageView.size.height),
            temperatureDegreeImageView.widthAnchor.constraint(equalToConstant: Style.TemperatureDegreeImageView.size.width)
        ])
        
        temperatureDegreeImageView.image = Style.TemperatureDegreeImageView.image
        temperatureDegreeImageView.contentMode = .scaleAspectFit
    }
    
    private func configureCloudIconImageView() {
        introImageView.addSubviews(cloudIconImageView)
        NSLayoutConstraint.activate([
            cloudIconImageView.topAnchor.constraint(equalTo: introImageView.topAnchor, constant: Style.CloudIconImageView.margin.top),
            cloudIconImageView.trailingAnchor.constraint(equalTo: introImageView.trailingAnchor, constant: -Style.CloudIconImageView.margin.right),
            cloudIconImageView.heightAnchor.constraint(equalToConstant: Style.CloudIconImageView.size.height),
            cloudIconImageView.widthAnchor.constraint(equalToConstant: Style.CloudIconImageView.size.width)
        ])
        
        cloudIconImageView.image = Style.CloudIconImageView.image
        cloudIconImageView.contentMode = .scaleAspectFit
    }
    
    private func configureNextButton() {
        addSubviews(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.NextButton.margin.left),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.NextButton.margin.right),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Style.NextButton.margin.bottom)
        ])
    }
}

private extension AuthIntroView {
    enum Style {
        enum TitleLabel {
            static let margin: CGFloat = 120
            static let numberOfLines = 0
            static let lingHeight: CGFloat = 44.8
            static let text = "추운데 뭐 입을까?\n더 이상 고민고민하지마"
            static let textColor = CommonAsset.Colors.gray08.color
            static let textAlignment: NSTextAlignment = .center
            static let font = FitftyFont.appleSDBold(size: 32).font
        }
        
        enum IntroBackgroundImageView {
            static let margin: CGFloat = 40
            static let maxHeight: CGFloat = 337
            static let image = CommonAsset.Images.introImage.image
        }
        
        enum IntroImageView {
            static let margin: UIEdgeInsets = .init(top: 0, left: 40, bottom: 0, right: 40)
            static let image = CommonAsset.Images.sample.image
        }
        
        enum TemperatureImageView {
            static let margin: UIEdgeInsets = .init(top: 0, left: 24, bottom: 68, right: 0)
            static let size: CGSize = .init(width: 46, height: 72)
            static let image = CommonAsset.Images.introTemperature.image
        }
        
        enum TemperatureDegreeImageView {
            static let margin: UIEdgeInsets = .init(top: 0, left: 6, bottom: 53, right: 0)
            static let size: CGSize = .init(width: 17, height: 17)
            static let image = CommonAsset.Images.introTemperatureDegree.image
        }
        
        enum CloudIconImageView {
            static let margin: UIEdgeInsets = .init(top: 28, left: 0, bottom: 0, right: 22)
            static let size: CGSize = .init(width: 43, height: 31)
            static let image = CommonAsset.Images.introCloudSun.image
        }
        
        enum NextButton {
            static let margin: UIEdgeInsets = .init(top: 64, left: 20, bottom: 100, right: 20)
            static let text = "계속하기"
        }
    }
}
