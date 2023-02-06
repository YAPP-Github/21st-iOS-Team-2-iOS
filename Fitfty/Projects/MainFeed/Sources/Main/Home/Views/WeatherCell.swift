//
//  WeatherCell.swift
//  MainFeed
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WeatherCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 74, height: 72)
    }
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: .zero)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: .zero,
            leading: 12,
            bottom: .zero,
            trailing: 12
        )
        stackView.addArrangedSubviews(hourLabel, weatherIconImageView, tempLabel)
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        return view
    }()
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = FitftyFont.appleSDSemiBold(size: 12).font
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.text = "24시"
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.widthAnchor.constraint(equalToConstant: 48).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.cloudAndSun.image
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return imageView
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray04.color
        label.font = FitftyFont.SFProDisplayBold(size: 12).font
        label.text = "12°"
        return label
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
    
    private func configure() {
        contentView.addSubviews(backgroundStackView, separatorView)
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func setUpHourLabel(by isCurrentTime: Bool) {
        hourLabel.textColor = isCurrentTime ? .white : CommonAsset.Colors.gray04.color
        hourLabel.backgroundColor = isCurrentTime ? .black : .white
        tempLabel.textColor = isCurrentTime ? CommonAsset.Colors.gray08.color : CommonAsset.Colors.gray04.color
    }
    
    private func reset() {
        hourLabel.text = "24시"
        weatherIconImageView.image = CommonAsset.Images.sunny.image
        hourLabel.textColor = CommonAsset.Colors.gray04.color
        tempLabel.textColor = CommonAsset.Colors.gray04.color
        hourLabel.backgroundColor = .white
        separatorView.isHidden = false
    }
    
}

extension WeatherCell {
    
    func setUp(hour: String, image: UIImage?, temp: Int, isCurrentTime: Bool) {
        setUpHourLabel(by: isCurrentTime)
        hourLabel.text = isCurrentTime ? "지금" : hour
        weatherIconImageView.image = image
        tempLabel.text = "\(temp)°"
    }
    
    func setUpSeparator(isHidden: Bool) {
        separatorView.isHidden = isHidden
    }
    
}
