//
//  AuthView.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class AuthView: UIView {
    private let logoImageView = UIImageView()
    private let snsLabel = UILabel()
    private let snsImageStackView = UIStackView()
    private let kakaoButton = UIButton()
    private let appleButton = UIButton()
    private let enterWithoutLoginButton = UIButton()
    private let loginProblemLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setTargetEnterButtonWithoutLogin() {
        
    }
    
    private func configure() {
        configureLogoImageView()
        configureLoginProblemLabel()
        configureEnterButtonWithoutLogin()
        configureSnsImageStackView()
        configureSnsLabel()
    }
    
    private func configureLogoImageView() {
        addSubviews(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: Style.LogoImageView.size.width),
            logoImageView.heightAnchor.constraint(equalToConstant: Style.LogoImageView.size.height)
        ])
        
        logoImageView.image = Style.LogoImageView.image
    }
    
    private func configureLoginProblemLabel() {
        addSubviews(loginProblemLabel)
        NSLayoutConstraint.activate([
            loginProblemLabel.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                      constant: -Style.LoginProblemLabel.margin),
            loginProblemLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        loginProblemLabel.text = Style.LoginProblemLabel.text
        loginProblemLabel.font = Style.LoginProblemLabel.font
    }
    
    private func configureEnterButtonWithoutLogin() {
        addSubviews(enterWithoutLoginButton)
        NSLayoutConstraint.activate([
            enterWithoutLoginButton.bottomAnchor.constraint(equalTo: loginProblemLabel.topAnchor,
                                                            constant: -Style.EnterWithoutLoginButton.margin),
            enterWithoutLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            enterWithoutLoginButton.widthAnchor.constraint(equalToConstant: Style.EnterWithoutLoginButton.size.width),
            enterWithoutLoginButton.heightAnchor.constraint(equalToConstant: Style.EnterWithoutLoginButton.size.height)
        ])
        
        enterWithoutLoginButton.setTitle(Style.EnterWithoutLoginButton.title, for: .normal)
        enterWithoutLoginButton.setTitleColor(Style.EnterWithoutLoginButton.textColor.color, for: .normal)
        enterWithoutLoginButton.layer.borderColor = Style.EnterWithoutLoginButton.borderColor.color.cgColor
        enterWithoutLoginButton.layer.cornerRadius = Style.EnterWithoutLoginButton.radius
    }
    
    private func configureSnsImageStackView() {
        addSubviews(snsImageStackView)
        NSLayoutConstraint.activate([
            snsImageStackView.bottomAnchor.constraint(equalTo: enterWithoutLoginButton.topAnchor,
                                                      constant: -Style.EnterWithoutLoginButton.margin),
            snsImageStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        snsImageStackView.axis = Style.SnsImageStackView.axis
        snsImageStackView.alignment = Style.SnsImageStackView.alignment
        snsImageStackView.spacing = Style.SnsImageStackView.spacing
        
        configureKakaoButton()
        configureAppleButton()
    }
    
    private func configureKakaoButton() {
        snsImageStackView.addArrangedSubviews(kakaoButton)
        NSLayoutConstraint.activate([
            kakaoButton.heightAnchor.constraint(equalToConstant: Style.KakaoButton.size.height),
            kakaoButton.widthAnchor.constraint(equalToConstant: Style.KakaoButton.size.width)
        ])
        
        kakaoButton.setImage(Style.KakaoButton.image, for: .normal)
    }
    
    private func configureAppleButton() {
        snsImageStackView.addArrangedSubviews(appleButton)
        NSLayoutConstraint.activate([
            appleButton.heightAnchor.constraint(equalToConstant: Style.AppleButton.size.height),
            appleButton.widthAnchor.constraint(equalToConstant: Style.AppleButton.size.width)
        ])
        
        appleButton.setImage(Style.AppleButton.image, for: .normal)
    }
    
    private func configureSnsLabel() {
        addSubviews(snsLabel)
        NSLayoutConstraint.activate([
            snsImageStackView.bottomAnchor.constraint(equalTo: snsImageStackView.topAnchor,
                                                      constant: -Style.SnsLabel.margin),
            snsImageStackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

private extension AuthView {
    enum Style {
        enum LogoImageView {
            static let size = CGSize(width: 103, height: 78)
            static let image = CommonAsset.Images.fitftyLogoImage.image
        }
        
        enum LoginProblemLabel {
            static let margin: CGFloat = 72
            static let text = "로그인에 문제가 있나요?"
            static let textColor = CommonAsset.Colors.gray2Light
            static let font = FitftyFont.appleSDMedium(size: 13).font
        }
        
        enum EnterWithoutLoginButton {
            static let size = CGSize(width: 166, height: 38)
            static let margin: CGFloat = 20
            static let borderColor = CommonAsset.Colors.gray5Light
            static let textColor = CommonAsset.Colors.gray5Light
            static let radius: CGFloat = 32
            static let font = FitftyFont.appleSDMedium(size: 13).font
            static let title = "둘러보기"
        }
        
        enum SnsImageStackView {
            static let margin: CGFloat = 20
            static let spacing: CGFloat = 16
            static let axis: NSLayoutConstraint.Axis = .horizontal
            static let alignment: UIStackView.Alignment = .center
        }
        
        enum KakaoButton {
            static let size = CGSize(width: 56, height: 56)
            static let image = CommonAsset.Images.kakaoLoginImage.image
        }
        
        enum AppleButton {
            static let size = CGSize(width: 56, height: 56)
            static let image = CommonAsset.Images.appleLoginImage.image
        }
        
        enum SnsLabel {
            static let margin: CGFloat = 16
            static let text = "SNS 계정으로 간편 가입하기"
            static let textColor = CommonAsset.Colors.grayLight
            static let font = FitftyFont.appleSDMedium(size: 13).font
        }
    }
}
