//
//  AuthPermissionView.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/02/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

final class AuthPermissionView: UIView {
    private let titleLabel = UILabel()
    private let permissionImageView = UIImageView()
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
    
    func setNextButtonTarget(target: Any?, action: Selector) {
        nextButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func configure() {
        configureTitleLabel()
        configurePermissionImageView()
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
    
    private func configurePermissionImageView() {
        addSubviews(permissionImageView)
        NSLayoutConstraint.activate([
            permissionImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.PermissionImageView.margin.top),
            permissionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.PermissionImageView.margin.left),
            permissionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.PermissionImageView.margin.right),
            permissionImageView.heightAnchor.constraint(equalToConstant: Style.PermissionImageView.size.height)
        ])
        
        permissionImageView.image = Style.PermissionImageView.image
        permissionImageView.contentMode = .scaleAspectFit
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

private extension AuthPermissionView {
    enum Style {
        enum TitleLabel {
            static let margin: CGFloat = 120
            static let numberOfLines = 0
            static let lingHeight: CGFloat = 44.8
            static let text = "앱 서비스 이용을 위해\n접근 권한을 확인해주세요."
            static let textColor = CommonAsset.Colors.gray08.color
            static let textAlignment: NSTextAlignment = .center
            static let font = FitftyFont.appleSDBold(size: 32).font
        }
        
        enum PermissionImageView {
            static let margin: UIEdgeInsets = .init(top: 72, left: 62, bottom: 0, right: 93)
            static let size: CGSize = .init(width: 208, height: 136)
            static let image = CommonAsset.Images.permissionImage.image
        }
        
        enum NextButton {
            static let margin: UIEdgeInsets = .init(top: 64, left: 20, bottom: 100, right: 20)
            static let text = "계속하기"
        }
    }
}
