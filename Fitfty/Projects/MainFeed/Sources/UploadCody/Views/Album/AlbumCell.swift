//
//  AlbumCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

class AlbumCell: UICollectionViewCell {
    private lazy var imageView = UIImageView()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnAlbumUnSelcted.image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.image = CommonAsset.Images.sample.image
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(imageView, button)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            button.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
}
