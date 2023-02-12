//
//  WeatherTagCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/08.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WeatherTagCell: UICollectionViewCell {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: titleLabel.intrinsicContentSize.width + 25,
            height: 43
        )
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.backgroundColor = CommonAsset.Colors.gray01.color
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tapView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        return view
    }()
    
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        return CGSize(width: intrinsicContentSize.width, height: intrinsicContentSize.height)
    }
    
    override func prepareForReuse() {
        tapView.isHidden = true
    }
    
    deinit {
        removeNotificationCenter()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsLayout()
        setNotificationCenter()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: .showKeyboard,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resignKeyboard),
            name: .resignKeyboard,
            object: nil
        )
    }
    
    private func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(
            self,
            name: .showKeyboard,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .resignKeyboard,
            object: nil
        )
    }
    
    private func setUpConstraintsLayout() {
        contentView.addSubviews(titleLabel, tapView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tapView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tapView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc func didTapView(_ sender: Any?) {
        tapView.isHidden = true
        NotificationCenter.default.post(name: .resignKeyboard, object: nil)
    }
    
    @objc func showKeyboard(_ sender: Any?) {
        tapView.isHidden = false
    }
    
    @objc func resignKeyboard(_ sender: Any?) {
        tapView.isHidden = true
    }
}

extension WeatherTagCell {
    func setUp(weahterTag: WeatherTag, isSelected: Bool) {
        titleLabel.text = weahterTag.emojiWeatherTag
        titleLabel.textColor = isSelected ? weahterTag.textColor : CommonAsset.Colors.gray06.color
        titleLabel.backgroundColor = isSelected ? weahterTag.backgroundColor : CommonAsset.Colors.gray01.color
    }
}
