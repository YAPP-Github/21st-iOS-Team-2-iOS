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
        stackView.addArrangedSubviews(weatherIconView, separator, tempView)
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
    
    private lazy var tempView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, alignment: .top, distribution: .fill, spacing: 6)
        stackView.addArrangedSubviews(temperatureLabel, ellipseView)
        return stackView
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "13"
        label.textColor = .black
        label.font = FitftyFont.antonRegular(size: 64).font
        label.heightAnchor.constraint(equalToConstant: 64).isActive = true
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var ellipseView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.ondo.image
        imageView.widthAnchor.constraint(equalToConstant: 17).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        return imageView
    }()
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 66).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var separator: UIView = {
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
        temperatureLabel.text = "\(temp)"
        weatherIconView.image = icon
    }
    
    func reset() {
        addressLabel.text = nil
        temperatureLabel.text = nil
    }
}

private extension AddressInfoView {
    
    func configure() {
        addSubviews(backgroundStackView)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            backgroundStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -35)
        ])
    }
}
