//
//  NicknameView.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine

import Common

final class NicknameView: UIView {
    private let statusView = OnboardingStatusView()
    private let titleLabel = UILabel()
    private let nicknameTextField = FitftyTextField(style: .normal, placeHolderText: "영문 숫자 조합 1자 이상의 닉네임 입력")
    
    private let warningContainerStackView = UIStackView()
    
    private let firstWarningStackView = UIStackView()
    private let firstWarningLabel = UILabel()
    private let firstWarningImageView = UIImageView()
    
    private let secondWarningStackView = UIStackView()
    private let secondWarningLabel = UILabel()
    private let secondWarningImageView = UIImageView()
    
    private let nextButton = FitftyButton(style: .disabled, title: Style.NextButton.text)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func getNickname() -> String {
        return nicknameTextField.text ?? ""
    }
    
    func nicknameTextPublisher() -> AnyPublisher<String, Never> {
        var textPublisher: AnyPublisher<String, Never> {
            NotificationCenter.default.publisher(
                for: UITextField.textDidChangeNotification,
                object: nicknameTextField
            )
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
        }
        return textPublisher
    }
    
    func setNextButtonTarget(target: Any?, action: Selector) {
        nextButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setNextButtonStyle(_ style: FitftyButtonStyle) {
        nextButton.setStyle(style)
    }
    
    func setNicknameTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        nicknameTextField.delegate = delegate
    }
    
    func setNicknameTextFieldStyle(_ style: FitftyTextFieldStyle) {
        nicknameTextField.setStyle(style: style)
    }
    
    func setNextButtonMoveUp(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.25, animations: {
                self.nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + 80)
            })
        }
    }
    
    func setNextButtonMoveDown(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.nextButton.transform = .identity
        })
    }
    
    func setFirstWarningState(isSuccess: Bool) {
        changeWarningState(isCheck: isSuccess, label: firstWarningLabel, imageView: firstWarningImageView)
    }
    
    func setSecondWarningState(isSuccess: Bool) {
        changeWarningState(isCheck: isSuccess, label: secondWarningLabel, imageView: secondWarningImageView)
    }
    
    private func changeWarningState(isCheck: Bool, label: UILabel, imageView: UIImageView) {
        if isCheck {
            label.textColor = Style.Warning.successTextColor
            imageView.image = Style.Warning.successImage
        } else {
            label.textColor = Style.Warning.errorTextColor
            imageView.image = Style.Warning.errorImage
        }
    }
    
    private func configure() {
        configureStatusView()
        configureTitleLabel()
        configureNicknameTextField()
        configureWarningContainerStackView()
        configureNextButton()
    }
    
    private func configureStatusView() {
        addSubviews(statusView)
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Style.StatusView.margin.top),
            statusView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.StatusView.margin.left),
            statusView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.StatusView.margin.right),
            statusView.heightAnchor.constraint(equalToConstant: Style.StatusView.height)
        ])
        
        statusView.setStep(index: 2)
    }
    
    private func configureTitleLabel() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: Style.TitleLabel.margin.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.TitleLabel.margin.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.TitleLabel.margin.right)
        ])
        
        titleLabel.numberOfLines = Style.TitleLabel.numberOfLines
        titleLabel.text = Style.TitleLabel.text
        titleLabel.textColor = Style.TitleLabel.textColor
        titleLabel.font = Style.TitleLabel.font
        titleLabel.setTextWithLineHeight(lineHeight: Style.TitleLabel.lingHeight)
    }
    
    private func configureNicknameTextField() {
        addSubviews(nicknameTextField)
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.NicknameTextField.margin.top),
            nicknameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.NicknameTextField.margin.left),
            nicknameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.NicknameTextField.margin.right)
        ])
    }
    
    private func configureWarningContainerStackView() {
        addSubviews(warningContainerStackView)
        NSLayoutConstraint.activate([
            warningContainerStackView.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: Style.WarningContainerStackView.margin.top),
            warningContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.WarningContainerStackView.margin.left),
            warningContainerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.WarningContainerStackView.margin.right)
        ])
        
        warningContainerStackView.axis = Style.WarningContainerStackView.axis
        warningContainerStackView.spacing = Style.WarningContainerStackView.spacing
        
        configureFirstWarningStackView()
        configureSecondWarningStackView()
    }
    
    private func configureFirstWarningStackView() {
        warningContainerStackView.addArrangedSubviews(firstWarningStackView)
        
        firstWarningStackView.axis = Style.FirstWarningStackView.axis
        firstWarningStackView.spacing = Style.FirstWarningStackView.spacing
        
        configureFirstWarningImageView()
        configureFirstWarningLabel()
    }
    
    private func configureFirstWarningImageView() {
        firstWarningStackView.addArrangedSubviews(firstWarningImageView)
        NSLayoutConstraint.activate([
            firstWarningImageView.heightAnchor.constraint(equalToConstant: Style.Warning.size.height),
            firstWarningImageView.widthAnchor.constraint(equalToConstant: Style.Warning.size.width)
        ])
        
        firstWarningImageView.image = Style.Warning.errorImage
        firstWarningImageView.contentMode = .scaleAspectFit
    }
    
    private func configureFirstWarningLabel() {
        firstWarningStackView.addArrangedSubviews(firstWarningLabel)
        
        firstWarningLabel.text = Style.FirstWarningLabel.text
        firstWarningLabel.textColor = Style.Warning.errorTextColor
        firstWarningLabel.font = Style.Warning.font
    }
    
    private func configureSecondWarningStackView() {
        warningContainerStackView.addArrangedSubviews(secondWarningStackView)
        
        secondWarningStackView.axis = Style.SecondWarningStackView.axis
        secondWarningStackView.spacing = Style.SecondWarningStackView.spacing
        
        configureSecondWarningImageView()
        configureSecondWarningLabel()
    }
    
    private func configureSecondWarningImageView() {
        secondWarningStackView.addArrangedSubviews(secondWarningImageView)
        NSLayoutConstraint.activate([
            secondWarningImageView.heightAnchor.constraint(equalToConstant: Style.Warning.size.height),
            secondWarningImageView.widthAnchor.constraint(equalToConstant: Style.Warning.size.width)
        ])
        
        secondWarningImageView.image = Style.Warning.errorImage
        firstWarningImageView.contentMode = .scaleAspectFit
    }
    
    private func configureSecondWarningLabel() {
        secondWarningStackView.addArrangedSubviews(secondWarningLabel)
        
        secondWarningLabel.text = Style.SecondWarningLabel.text
        secondWarningLabel.textColor = Style.Warning.errorTextColor
        secondWarningLabel.font = Style.Warning.font
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

private extension NicknameView {
    enum Style {
        enum StatusView {
            static let margin: UIEdgeInsets = .init(top: 18, left: 20, bottom: 0, right: 20)
            static let height: CGFloat = 4
        }
        
        enum TitleLabel {
            static let margin: UIEdgeInsets = .init(top: 61, left: 20, bottom: 0, right: 32)
            static let numberOfLines = 0
            static let lingHeight: CGFloat = 44.8
            static let text = "핏프티에서 사용할\n닉네임을 입력해주세요."
            static let textColor = CommonAsset.Colors.gray08.color
            static let font = FitftyFont.appleSDBold(size: 32).font
        }
        
        enum NicknameTextField {
            static let margin: UIEdgeInsets = .init(top: 36, left: 20, bottom: 0, right: 20)
        }
        
        enum WarningContainerStackView {
            static let margin: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: 20)
            static let spacing: CGFloat = 8
            static let axis: NSLayoutConstraint.Axis = .vertical
        }
        
        enum Warning {
            static let successTextColor = CommonAsset.Colors.success.color
            static let errorTextColor = CommonAsset.Colors.error.color
            static let font = FitftyFont.appleSDSemiBold(size: 13).font
            
            static let successImage = CommonAsset.Images.iconCheck.image
            static let errorImage = CommonAsset.Images.iconClose.image
            static let size: CGSize = .init(width: 18, height: 18)
        }
        
        enum FirstWarningStackView {
            static let spacing: CGFloat = 11.75
            static let axis: NSLayoutConstraint.Axis = .horizontal
        }
        
        enum FirstWarningLabel {
            static let text = "1자 이상의 영문 혹은 영문과 숫자를 조합"
        }
        
        enum SecondWarningStackView {
            static let spacing: CGFloat = 11.75
            static let axis: NSLayoutConstraint.Axis = .horizontal
        }
        
        enum SecondWarningLabel {
            static let text = "닉네임 중복확인"
        }
        
        enum NextButton {
            static let margin: UIEdgeInsets = .init(top: 0, left: 20, bottom: 100, right: 20)
            static let text = "다음"
        }
    }
}
