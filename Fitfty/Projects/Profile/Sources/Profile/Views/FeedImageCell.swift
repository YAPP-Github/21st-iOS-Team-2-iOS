//
//  ProfileCollectionViewCell.swift
//  Profile
//
//  Created by 임영선 on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common
import Kingfisher

final class FeedImageCell: UICollectionViewCell {
    
    private lazy var feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        contentView.addSubviews(feedImageView)
        NSLayoutConstraint.activate([
            feedImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            feedImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func reset() {
        feedImageView.kf.cancelDownloadTask()
        feedImageView.image = nil
    }
}

extension FeedImageCell {
    
    func setUp(filepath: String) {
        if let url = URL(string: filepath) {
            feedImageView.kf.indicatorType = .activity
            let processor = DownsamplingImageProcessor(
                size: CGSize(
                    width: feedImageView.bounds.size.width == 0 ? 200 : feedImageView.bounds.size.width,
                    height: feedImageView.bounds.size.height == 0 ? 200 : feedImageView.bounds.size.height
                )
            )
            feedImageView.kf.setImage(with: url, options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ])
        }
    }
}
