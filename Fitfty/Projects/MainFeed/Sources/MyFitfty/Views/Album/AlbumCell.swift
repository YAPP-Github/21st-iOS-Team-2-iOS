//
//  AlbumCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class AlbumCell: UICollectionViewCell {
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var photoButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnAlbumUnSelcted.image, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                photoButton.setImage(CommonAsset.Images.btnAlbumSelected.image, for: .normal)
            } else {
                photoButton.setImage(CommonAsset.Images.btnAlbumUnSelcted.image, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        photoImageView.image = CommonAsset.Images.sample.image
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(photoImageView, photoButton)
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            photoButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
}

extension AlbumCell {
    
    func setImage(image: UIImage) {
        photoImageView.image = image
    }

}
