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
        label.textColor = .label
        label.font = .preferredFont(for: .callout, weight: .semibold)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            font: .preferredFont(for: .subheadline, weight: .regular),
            scale: .large
        )
        button.setImage(UIImage(systemName: "chevron.down")?.withConfiguration(config), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
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
        spacing = 2
        addArrangedSubviews(locationLabel, locationButton)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        print(#function)
    }
    
}
