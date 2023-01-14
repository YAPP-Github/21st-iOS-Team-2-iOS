//
//  AddressInfoView.swift
//  MainFeed
//
//  Created by Ari on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class AddressInfoView: UIView {
    
    private lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 16)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(addressLabel, weatherView)
        return stackView
    }()
    
    private lazy var weatherView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 15)
        stackView.backgroundColor = .clear
        stackView.addArrangedSubviews(weatherIconView, ellipseView, temperatureLabel)
        return stackView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "강원도, 춘천시"
        label.textColor = .black
        label.font = FitftyFont.SFProDisplayBold(size: 24).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "13°"
        label.textColor = .black
        label.font = FitftyFont.SFProDisplayBold(size: 72).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var ellipseView: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 6).isActive = true
        view.heightAnchor.constraint(equalToConstant: 6).isActive = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUp(address: String, temp: Int, icon: UIImage?) {
        addressLabel.text = address
        temperatureLabel.text = "\(temp)°"
        weatherIconView.image = icon
    }
}

private extension AddressInfoView {
    
    func configure() {
        addSubviews(backgroundStackView)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            backgroundStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
