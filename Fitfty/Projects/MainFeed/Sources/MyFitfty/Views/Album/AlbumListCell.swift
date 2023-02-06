//
//  AlbumListCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/05.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

class AlbumListCell: UITableViewCell {
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDSemiBold(size: 16).font
        label.textColor = CommonAsset.Colors.gray08.color
        return label
    }()
    
    private lazy var photoCountLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplayBold(size: 12).font
        label.textColor = CommonAsset.Colors.gray05.color
        return label
    }()
    
    private lazy var photoInfoStackView: UIStackView = {
        let stackView = UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fill,
            spacing: 2
        )
        stackView.addArrangedSubviews(titleLabel, photoCountLabel)
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraintsLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(thumbnailImageView, photoInfoStackView)
        NSLayoutConstraint.activate([
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 48),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 48),
            thumbnailImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            photoInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            photoInfoStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16)
        ])
    }

}

extension AlbumListCell {
    func setUp(image: UIImage, title: String, photoCount: String) {
        thumbnailImageView.image = image
        titleLabel.text = title
        photoCountLabel.text = photoCount
    }
}
