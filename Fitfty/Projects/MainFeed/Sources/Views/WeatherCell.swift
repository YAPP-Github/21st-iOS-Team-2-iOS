//
//  WeatherCell.swift
//  MainFeed
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 74, height: 72)
    }
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .clear
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: .zero,
            leading: 12,
            bottom: 2,
            trailing: 12
        )
        stackView.addArrangedSubviews(hourLabel, weatherIconImageView)
        return stackView
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 72).isActive = true
        return view
    }()
    
    private lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .preferredFont(for: .footnote, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.text = "24시"
        label.backgroundColor = .white
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.widthAnchor.constraint(equalToConstant: 48).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return label
    }()
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cloud")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
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
        hourLabel.textColor = isCurrentTime ? .white : .systemGray
        hourLabel.backgroundColor = isCurrentTime ? .black : .white
    }
    
    private func reset() {
        hourLabel.text = "24시"
        weatherIconImageView.image = UIImage(systemName: "cloud")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        hourLabel.textColor = .systemGray
        hourLabel.backgroundColor = .white
        separatorView.isHidden = false
    }
    
}

extension WeatherCell {
    func setUp(hour: String, image: UIImage?, isCurrentTime: Bool) {
        setUpHourLabel(by: isCurrentTime)
        hourLabel.text = "\(hour)시"
        weatherIconImageView.image = image
    }
    
    func setUpSeparator(isHidden: Bool) {
        separatorView.isHidden = isHidden
    }
}
