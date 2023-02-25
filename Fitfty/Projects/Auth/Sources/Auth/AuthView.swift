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
    private let acceptPrivacyTextView = LinksTextView()
    private let kakaoButton = UIButton()
    private let appleButton = UIButton()
    private let enterWithoutLoginButton = UIButton()
    private let loginProblemButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEnterWithoutLoginButtonTarget(target: Any?, action: Selector) {
        enterWithoutLoginButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setKakaoButtonTarget(target: Any?, action: Selector) {
        kakaoButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setAppleButtonTarget(target: Any?, action: Selector) {
        appleButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setLoginProblemButtonTarget(target: Any?, action: Selector) {
        loginProblemButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setAcceptPrivacyTextViewLinkAction(tapLink: @escaping (URL) -> Bool) {
        acceptPrivacyTextView.onLinkTap = tapLink
    }
    
    private func configure() {
        configureLogoImageView()
        configureLoginProblemButton()
        configureEnterButtonWithoutLogin()
        configureAcceptPrivacyTextView()
        configureSnsImageStackView()
        configureSnsLabel()
    }
    
    private func configureLogoImageView() {
        addSubviews(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -Style.LogoImageView.margin),
            logoImageView.widthAnchor.constraint(equalToConstant: Style.LogoImageView.size.width),
            logoImageView.heightAnchor.constraint(equalToConstant: Style.LogoImageView.size.height)
        ])
        
        logoImageView.image = Style.LogoImageView.image
        logoImageView.contentMode = .scaleAspectFit
    }
    
    private func configureLoginProblemButton() {
        addSubviews(loginProblemButton)
        NSLayoutConstraint.activate([
            loginProblemButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                      constant: -Style.LoginProblemLabel.margin),
            loginProblemButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        loginProblemButton.titleLabel?.font = Style.LoginProblemLabel.font
        loginProblemButton.setTitle(Style.LoginProblemLabel.text, for: .normal)
        loginProblemButton.setTitleColor(Style.LoginProblemLabel.textColor.color, for: .normal)
    }
    
    private func configureEnterButtonWithoutLogin() {
        addSubviews(enterWithoutLoginButton)
        NSLayoutConstraint.activate([
            enterWithoutLoginButton.bottomAnchor.constraint(equalTo: loginProblemButton.topAnchor,
                                                            constant: -Style.EnterWithoutLoginButton.margin),
            enterWithoutLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            enterWithoutLoginButton.widthAnchor.constraint(equalToConstant: Style.EnterWithoutLoginButton.size.width),
            enterWithoutLoginButton.heightAnchor.constraint(equalToConstant: Style.EnterWithoutLoginButton.size.height)
        ])
        
        enterWithoutLoginButton.titleLabel?.font = Style.EnterWithoutLoginButton.font
        enterWithoutLoginButton.setTitle(Style.EnterWithoutLoginButton.title, for: .normal)
        enterWithoutLoginButton.setTitleColor(Style.EnterWithoutLoginButton.textColor.color, for: .normal)
        enterWithoutLoginButton.layer.borderColor = Style.EnterWithoutLoginButton.borderColor.color.cgColor
        enterWithoutLoginButton.layer.cornerRadius = Style.EnterWithoutLoginButton.radius
        enterWithoutLoginButton.layer.borderWidth = Style.EnterWithoutLoginButton.borderWidth
    }
    
    private func configureAcceptPrivacyTextView() {
        addSubviews(acceptPrivacyTextView)
        NSLayoutConstraint.activate([
            acceptPrivacyTextView.bottomAnchor.constraint(equalTo: enterWithoutLoginButton.topAnchor,
                                                      constant: -Style.AcceptPrivacyTextView.margin),
            acceptPrivacyTextView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        let termsOfUse = Style.AcceptPrivacyTextView.termsOfUse
        let privacy = Style.AcceptPrivacyTextView.privacy
        
        acceptPrivacyTextView.font = Style.AcceptPrivacyTextView.font
        acceptPrivacyTextView.textColor = Style.AcceptPrivacyTextView.textColor.color
        acceptPrivacyTextView.text = "서비스 가입 시 \(termsOfUse) 및 \(privacy)에 동의하게 돼요."
        acceptPrivacyTextView.addLinks([
            termsOfUse: Style.AcceptPrivacyTextView.termsOfUseLink,
            privacy: Style.AcceptPrivacyTextView.privacyLink
        ])
    }
    
    private func configureSnsImageStackView() {
        addSubviews(snsImageStackView)
        NSLayoutConstraint.activate([
            snsImageStackView.bottomAnchor.constraint(equalTo: acceptPrivacyTextView.topAnchor,
                                                      constant: -Style.SnsImageStackView.margin),
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
            snsLabel.bottomAnchor.constraint(equalTo: snsImageStackView.topAnchor,
                                                      constant: -Style.SnsLabel.margin),
            snsLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        snsLabel.text = Style.SnsLabel.text
        snsLabel.font = Style.SnsLabel.font
        snsLabel.textColor = Style.SnsLabel.textColor.color
    }
}

private extension AuthView {
    enum Style {
        enum LogoImageView {
            static let size = CGSize(width: 135, height: 46)
            static let margin: CGFloat = 80
            static let image = CommonAsset.Images.fitftyLogoImage.image
        }
        
        enum LoginProblemLabel {
            static let margin: CGFloat = 72
            static let text = "로그인에 문제가 있나요?"
            static let textColor = CommonAsset.Colors.gray04
            static let font = FitftyFont.appleSDMedium(size: 13).font
        }
        
        enum EnterWithoutLoginButton {
            static let size = CGSize(width: 166, height: 38)
            static let margin: CGFloat = 42
            static let borderColor = CommonAsset.Colors.gray02
            static let borderWidth: CGFloat = 1
            static let textColor = CommonAsset.Colors.gray05
            static let radius: CGFloat = 16
            static let font = FitftyFont.appleSDMedium(size: 13).font
            static let title = "둘러보기"
        }
        
        enum AcceptPrivacyTextView {
            static let margin: CGFloat = 20
            static let text = "서비스 가입 시 이용약관 및 개인정보취급방침에 동의하게 돼요."
            static let privacy = "개인정보이용방침"
            static let privacyLink = "https://maze-mozzarella-6e5.notion.site/ed1e98c3fee5417b89f85543f4a398d2"
            static let termsOfUse = "이용약관"
            static let termsOfUseLink = "https://maze-mozzarella-6e5.notion.site/dd559e6017ee499fa569148b8621966d"
            static let textColor = CommonAsset.Colors.gray04
            static let font = FitftyFont.appleSDBold(size: 12).font
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
            static let textColor = CommonAsset.Colors.gray05
            static let font = FitftyFont.appleSDBold(size: 13).font
        }
    }
}
