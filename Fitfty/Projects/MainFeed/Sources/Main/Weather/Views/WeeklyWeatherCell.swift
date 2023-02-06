//
//  WeeklyWeatherCell.swift
//  MainFeed
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WeeklyWeatherCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: safeAreaLayoutGuide.layoutFrame.width, height: 72)
    }
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: .zero)
        stackView.backgroundColor = .clear
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 20
        )
        stackView.addArrangedSubviews(dateView, separatorView, amInfoView, pmInfoView, tempView)
        return stackView
    }()
    
    private lazy var dateView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fillEqually, spacing: .zero)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(weekLabel, monthDayLabel)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: .zero,
            leading: .zero,
            bottom: .zero,
            trailing: 12
        )
        stackView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        return stackView
    }()
    
    private lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FitftyFont.SFProDisplaySemibold(size: 14).font
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.text = "월"
        return label
    }()
    
    private lazy var monthDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = FitftyFont.SFProDisplaySemibold(size: 13).font
        label.text = "12.19"
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return view
    }()
    
    private lazy var amInfoView: WeatherIconView = {
        let infoView = WeatherIconView()
        infoView.setContentHuggingPriority(.required, for: .horizontal)
        return infoView
    }()
    
    private lazy var pmInfoView: WeatherIconView = {
        let infoView = WeatherIconView()
        return infoView
    }()
    
    private lazy var tempView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .trailing, distribution: .fill, spacing: 5)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(minTempLabel, diagonalLabel, maxTempLabel)
        return stackView
    }()
    
    private lazy var minTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemBlue
        label.font = FitftyFont.SFProDisplaySemibold(size: 13).font
        label.textAlignment = .right
        label.text = "-12°"
        return label
    }()
    
    private lazy var diagonalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FitftyFont.SFProDisplaySemibold(size: 13).font
        label.text = "/"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var maxTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = FitftyFont.SFProDisplaySemibold(size: 13).font
        label.text = "3°"
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var highlightedView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.blue.color
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: .zero, y: .zero, width: safeAreaLayoutGuide.layoutFrame.width, height: 72)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.8)
        gradientLayer.endPoint = CGPoint(x: 0.9, y: 1)
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, CommonAsset.Colors.purple.color.cgColor]
        gradientLayer.locations = [-0.9]
        gradientLayer.cornerRadius = 8
        view.layer.addSublayer(gradientLayer)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        return CGSize(width: intrinsicContentSize.width, height: intrinsicContentSize.height)
    }
    
    private func configure() {
        contentView.addSubviews(highlightedView, backgroundStackView)
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            highlightedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            highlightedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            highlightedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            highlightedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func reset() {
        weekLabel.text = nil
        monthDayLabel.text = nil
        amInfoView.reset()
        pmInfoView.reset()
        minTempLabel.text = nil
        maxTempLabel.text = nil
        highlightedView.isHidden = true
    }
    
}

extension WeeklyWeatherCell {
    
    func setUp() {
        weekLabel.text = "월"
        monthDayLabel.text = "12.19"
        amInfoView.setUp(meridiem: "오전", precipitation: "0%", icon: CommonAsset.Images.sunny.image)
        pmInfoView.setUp(meridiem: "오후", precipitation: "10%", icon: CommonAsset.Images.cloudAndSun.image)
        minTempLabel.text = "-12°"
        maxTempLabel.text = "3°"

    }
    
    func highlighted() {
        highlightedView.isHidden = false
    }
    
}
