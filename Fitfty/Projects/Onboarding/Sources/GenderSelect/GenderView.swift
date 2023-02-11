//
//  GenderView.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

final class GenderView: UIView {
    private let statusView = OnboardingStatusView()
    private let titleLabel = UILabel()
    private let maleButton = SelectableButton(style: .normal, title: Style.MaleButton.text)
    private let femaleButton = SelectableButton(style: .normal, title: Style.FeMaleButton.text)
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
    
    func setNextButtonTarget(target: Any?, action: Selector) {
        nextButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setNextButtonStyle(_ style: FitftyButtonStyle) {
        nextButton.setStyle(style)
    }
    
    func setMaleButtonStyle(style: SelectableButtonStyle) {
        maleButton.setStyle(style)
    }
    
    func setMaleButtonTarget(target: Any?, action: Selector) {
        maleButton.setButtonTarget(target: target, action: action)
    }
    
    func setFemaleButtonStyle(style: SelectableButtonStyle) {
        femaleButton.setStyle(style)
    }
    
    func setFemaleButtonTarget(target: Any?, action: Selector) {
        femaleButton.setButtonTarget(target: target, action: action)
    }
    
    private func configure() {
        configureStatusView()
        configureTitleLabel()
        configureMaleButton()
        configureFemaleButton()
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
    
    private func configureMaleButton() {
        addSubviews(maleButton)
        NSLayoutConstraint.activate([
            maleButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.MaleButton.margin.top),
            maleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.MaleButton.margin.left),
            maleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.MaleButton.margin.right)
        ])
    }
    
    private func configureFemaleButton() {
        addSubviews(femaleButton)
        NSLayoutConstraint.activate([
            femaleButton.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: Style.FeMaleButton.margin.top),
            femaleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.FeMaleButton.margin.left),
            femaleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.FeMaleButton.margin.right)
        ])
    }
    
    private func configureNextButton() {
        addSubviews(nextButton)
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
        nextButton.layer.cornerRadius = Style.NextButton.radius
        nextButton.setHeight(Style.NextButton.height)
    }
}

private extension GenderView {
    enum Style {
        enum StatusView {
            static let margin: UIEdgeInsets = .init(top: 18, left: 20, bottom: 0, right: 20)
            static let height: CGFloat = 4
        }
        
        enum TitleLabel {
            static let margin: UIEdgeInsets = .init(top: 35, left: 20, bottom: 0, right: 32)
            static let numberOfLines = 0
            static let lingHeight: CGFloat = 44.8
            static let text = "보고싶은 모델의\n성별을 알려주세요."
            static let textColor = CommonAsset.Colors.gray08.color
            static let font = FitftyFont.appleSDBold(size: 32).font
        }
        
        enum MaleButton {
            static let margin: UIEdgeInsets = .init(top: 40, left: 20, bottom: 0, right: 20)
            static let text = "남성"
        }
        
        enum FeMaleButton {
            static let margin: UIEdgeInsets = .init(top: 16, left: 20, bottom: 0, right: 20)
            static let text = "여성"
        }
        
        enum NextButton {
            static let radius: CGFloat = 0
            static let height: CGFloat = 80
            static let text = "선택 완료"
        }
    }
}
