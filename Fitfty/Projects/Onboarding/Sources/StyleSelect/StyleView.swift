//
//  StyleView.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

import Common

final class StyleView: UIView {
    private let statusView = OnboardingStatusView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()

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
        configureStatusView()
        configureTitleLabel()
        configureSubTitleLabel()
    }
    
    private func configureStatusView() {
        addSubviews(statusView)
        NSLayoutConstraint.activate([
            statusView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Style.StatusView.margin.top),
            statusView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.StatusView.margin.left),
            statusView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.StatusView.margin.right),
            statusView.heightAnchor.constraint(equalToConstant: Style.StatusView.height)
        ])
        
        statusView.setStep(isFirst: false)
    }
    
    private func configureTitleLabel() {
        addSubviews(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: Style.TitleLabel.margin.top),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.TitleLabel.margin.left),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.TitleLabel.margin.right)
        ])
        
        titleLabel.text = Style.TitleLabel.text
        titleLabel.textColor = Style.TitleLabel.textColor
        titleLabel.font = Style.TitleLabel.font
    }
    
    private func configureSubTitleLabel() {
        addSubviews(subTitleLabel)
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Style.SubTitleLabel.margin.top),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.SubTitleLabel.margin.left),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Style.SubTitleLabel.margin.right)
        ])
        
        subTitleLabel.text = Style.SubTitleLabel.text
        subTitleLabel.textColor = Style.SubTitleLabel.textColor
        subTitleLabel.font = Style.SubTitleLabel.font
    }
}

private extension StyleView {
    enum Style {
        enum StatusView {
            static let margin: UIEdgeInsets = .init(top: 18, left: 20, bottom: 0, right: 20)
            static let height: CGFloat = 4
        }
        
        enum TitleLabel {
            static let margin: UIEdgeInsets = .init(top: 35, left: 20, bottom: 0, right: 32)
            static let text = "어떤 스타일을 좋아하세요?"
            static let textColor = CommonAsset.Colors.gray08.color
            static let font = FitftyFont.appleSDBold(size: 32).font
        }
        
        enum SubTitleLabel {
            static let margin: UIEdgeInsets = .init(top: 12, left: 20, bottom: 0, right: 20)
            static let text = "좋아하는 스타일을 두개 이상 선택해주세요."
            static let textColor = CommonAsset.Colors.gray05.color
            static let font = FitftyFont.appleSDMedium(size: 16).font
        }
    }
}
