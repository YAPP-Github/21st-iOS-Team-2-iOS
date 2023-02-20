//
//  WarningView.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/20.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class WarningView: UICollectionReusableView {
        
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "코디와 관련된 사진을 올렸는지 확인해 주세요. 코디와 관련 없는 콘텐츠는 별도 고지 없이 내부 규정에 따라 제재될 수 있어요."
        label.textColor = CommonAsset.Colors.gray04.color
        label.font = FitftyFont.appleSDSemiBold(size: 12).font
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.setTextWithLineHeight(lineHeight: 16.8)
        return label
    }()
    
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CommonAsset.Images.info.image
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(infoImageView, warningLabel)
        NSLayoutConstraint.activate([
            infoImageView.widthAnchor.constraint(equalToConstant: 11.67),
            infoImageView.heightAnchor.constraint(equalToConstant: 11.67),
            infoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 11),
            infoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            warningLabel.leadingAnchor.constraint(equalTo: infoImageView.trailingAnchor, constant: 3),
            warningLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            warningLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            warningLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setView() {
        self.layer.borderColor = CommonAsset.Colors.gray02.color.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
    }
}
