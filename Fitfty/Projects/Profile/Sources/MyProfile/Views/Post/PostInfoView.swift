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
        imageView.image = UIImage(systemName: "eye.fill")
        imageView.tintColor = CommonAsset.Colors.gray05.color
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
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.setCustomSpacing(6, after: weatherLabel)
        stackView.setCustomSpacing(6, after: dotLabel1)
        stackView.setCustomSpacing(6, after: hitsLabel)
        stackView.setCustomSpacing(6, after: dotLabel2)
        
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
        stackView.addArrangedSubviews(weatherLabel, dotLabel1, hitsImageView, hitsLabel, dotLabel2,
                            bookmarkImageView, bookmarkLabel)
       
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
        weatherLabel.text = weatherTag.weatherTagString
        hitsLabel.text = hits.insertComma
        bookmarkLabel.text = bookmark.insertComma
    }
}
