//
//  PostInfoView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/18.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class PostInfoView: UIView {
    
    private lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray05.color
        label.font = FitftyFont.appleSDSemiBold(size: 13).font
        return label
    }()
    
    private lazy var hitsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.eyeGray05.image
        imageView.tintColor = CommonAsset.Colors.gray05.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var hitsLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayMedium(size: 13).font
        label.textColor = CommonAsset.Colors.gray05.color
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bookmark.fill")
        imageView.tintColor = CommonAsset.Colors.gray05.color
        return imageView
    }()
    
    private lazy var bookmarkLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayMedium(size: 13).font
        label.textColor = CommonAsset.Colors.gray05.color
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var dotLabel1: UILabel = {
        let label = UILabel()
        label.text = "·"
        label.textColor = CommonAsset.Colors.gray03.color
        return label
    }()
    
    private lazy var dotLabel2: UILabel = {
        let label = UILabel()
        label.text = "·"
        label.textColor = CommonAsset.Colors.gray03.color
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            axis: .horizontal,
            alignment: .fill,
            distribution: .fill,
            spacing: 11
        )
        stackView.addArrangedSubviews(weatherLabel, dotLabel1, hitsImageView, hitsLabel, dotLabel2,
                            bookmarkImageView, bookmarkLabel)
        stackView.setCustomSpacing(4, after: hitsImageView)
        stackView.setCustomSpacing(4, after: bookmarkImageView)
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
        setUpConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpStackView() {
        self.backgroundColor = CommonAsset.Colors.gray01.color
    }
    
    private func setUpConstraintsLayout() {
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            hitsImageView.widthAnchor.constraint(equalToConstant: 14),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
}

extension PostInfoView {

    func setUp(hits: String, bookmark: String, weatherTag: WeatherTag) {
        weatherLabel.text = weatherTag.emojiWeatherTag
        hitsLabel.text = hits.insertComma
        bookmarkLabel.text = bookmark.insertComma
    }
    
}
