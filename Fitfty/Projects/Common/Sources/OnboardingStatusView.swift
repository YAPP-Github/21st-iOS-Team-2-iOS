//
//  OnboardingStatusView.swift
//  Common
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class OnboardingStatusView: UIView {
    let stackView = UIStackView()
    let firstStepView = UIView()
    let secondStepView = UIView()
    
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
        configureStackView()
        configureFirstStepView()
        configureSecondStepView()
    }
    
    private func configureStackView() {
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.axis = Style.StackView.axis
        stackView.spacing = Style.StackView.spacing
        stackView.distribution = Style.StackView.distribution
    }
    
    private func configureFirstStepView() {
        stackView.addArrangedSubviews(firstStepView)
        
        firstStepView.layer.cornerRadius = Style.StepView.radius
        firstStepView.layer.backgroundColor = Style.StepView.currentStepColor.cgColor
    }
    
    private func configureSecondStepView() {
        stackView.addArrangedSubviews(secondStepView)
        
        secondStepView.layer.cornerRadius = Style.StepView.radius
        secondStepView.layer.backgroundColor = Style.StepView.otherStepColor.cgColor
    }
}

private extension OnboardingStatusView {
    enum Style {
        enum StackView {
            static let spacing: CGFloat = 7
            static let axis: NSLayoutConstraint.Axis = .horizontal
            static let distribution: UIStackView.Distribution = .fillEqually
        }
        
        enum StepView {
            static let radius: CGFloat = 2
            static let currentStepColor = CommonAsset.Colors.primaryBlueLight.color
            static let otherStepColor = CommonAsset.Colors.gray01.color
        }
    }
}
