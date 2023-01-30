//
//  WeatherIconView.swift
//  MainFeed
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WeatherIconView: UIStackView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 90, height: 34)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: .zero)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(meridiemLabel, precipitationLabel)
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stackView
    }()
    
    private lazy var meridiemLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray04.color
        label.font = FitftyFont.SFProDisplaySemibold(size: 12).font
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.text = "오전"
        return label
    }()
    
    private lazy var precipitationLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.primaryBlueLight.color
        label.font = FitftyFont.SFProDisplayMedium(size: 12).font
        label.text = "0%"
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        imageView.image = CommonAsset.Images.lostOfCloudy.image
        return imageView
    }()
}

private extension WeatherIconView {
    
    func configure() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 8
        backgroundColor = .clear
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 10,
            leading: 14,
            bottom: 10,
            trailing: 12
        )
        addArrangedSubviews(labelStackView, iconImageView)
    }
}

extension WeatherIconView {
    
    func setUp(meridiem: String, precipitation: String, icon: UIImage?) {
        meridiemLabel.text = meridiem
        precipitationLabel.text = precipitation
        iconImageView.image = icon
    }
    
    func reset() {
        meridiemLabel.text = nil
        precipitationLabel.text = nil
        iconImageView.image = nil
    }
}
