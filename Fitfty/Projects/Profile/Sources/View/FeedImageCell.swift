//
//  ProfileCollectionViewCell.swift
//  Profile
//
//  Created by 임영선 on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class FeedImageCell: UICollectionViewCell {
    static let identifier: String = "FeedImageCell"
    
    private lazy var feedImageView: UIView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = CommonAsset.Images.profileSample.image
        return imageView
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        self.addSubview(feedImageView)
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        feedImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        feedImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        feedImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        feedImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
