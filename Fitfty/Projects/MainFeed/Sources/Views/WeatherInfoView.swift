//
//  WeatherInfoView.swift
//  MainFeed
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

final class WeatherInfoView: UIStackView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: -1.0, height: 80)
    }

    lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        stackView.addArrangedSubviews(conditionLabel, tempInfoLabel)
        return stackView
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 54, weight: .bold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .preferredFont(for: .footnote, weight: .regular)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var tempInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(for: .footnote, weight: .regular)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configure() {
        axis = .horizontal
        alignment = .top
        distribution = .fill
        spacing = 8
        backgroundColor = .clear
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        addArrangedSubviews(tempLabel, backgroundStackView)
    }
    
}

extension WeatherInfoView {
    
    func setUp(temp: Int, condition: String, minimum: Int, maximum: Int) {
        tempLabel.text = "\(temp)°"
        conditionLabel.text = condition
        tempInfoLabel.text = "최저\(minimum) ㆍ 최고\(maximum)"
    }
}
