//
//  LocationButton.swift
//  MainFeed
//
//  Created by Ari on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class LocationView: UIStackView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 105, height: 22)
    }
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FitftyFont.appleSDSemiBold(size: 15).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            font: .preferredFont(for: .subheadline, weight: .regular),
            scale: .medium
        )
        button.setImage(UIImage(systemName: "chevron.down")?.withConfiguration(config), for: .normal)
        button.tintColor = .black
        button.isUserInteractionEnabled = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    convenience init(_ location: String) {
        self.init(frame: .zero)
        configure()
        locationLabel.text = location
    }
    
    private func configure() {
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 3
        addArrangedSubviews(locationLabel, locationButton)
    }
    
    func update(location: String) {
        locationLabel.text = location
    }
}
