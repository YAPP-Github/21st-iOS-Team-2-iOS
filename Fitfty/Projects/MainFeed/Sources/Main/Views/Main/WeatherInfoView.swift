//
//  WeatherInfoView.swift
//  MainFeed
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

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
    
    private lazy var tempView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 3)
        stackView.addArrangedSubviews(tempLabel, ellipseView)
        return stackView
    }()

    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = FitftyFont.antonRegular(size: 64).font
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.heightAnchor.constraint(equalToConstant: 64).isActive = true
        return label
    }()
    
    private lazy var ellipseView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.ondo.image
        imageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()

    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray04.color
        label.textAlignment = .right
        label.font = FitftyFont.appleSDBold(size: 13).font
        return label
    }()

    private lazy var tempInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(for: .footnote, weight: .bold)
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
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 0, trailing: 20)
        addArrangedSubviews(tempView, backgroundStackView)
    }
    
}

extension WeatherInfoView {
    
    func setUp(temp: Int, condition: String, minimum: Int, maximum: Int) {
        tempLabel.text = temp.description
        conditionLabel.text = condition
        tempInfoLabel.text = "최저\(minimum) ㆍ 최고\(maximum)"
    }
    
}
