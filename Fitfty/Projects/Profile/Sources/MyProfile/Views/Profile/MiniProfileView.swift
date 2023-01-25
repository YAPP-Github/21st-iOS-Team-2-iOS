//
//  MiniProfileView.swift
//  Profile
//
//  Created by 임영선 on 2023/01/24.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class MiniProfileView: UIStackView {

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.SFProDisplaySemibold(size: 15).font
        label.textColor = CommonAsset.Colors.gray08.color
        return label
    }()
    
    init(imageSize: CGFloat, frame: CGRect) {
        super.init(frame: frame)
        setConstraintsLayout(imageSize: imageSize)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout(imageSize: CGFloat) {
        addArrangedSubviews(profileImageView, nicknameLabel)
        self.spacing = 12
        profileImageView.layer.cornerRadius = imageSize/2
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: imageSize),
            profileImageView.widthAnchor.constraint(equalToConstant: imageSize)
        ])
    }
    
}

extension MiniProfileView {
    func setUp(image: UIImage, nickname: String) {
        profileImageView.image = image
        nicknameLabel.text = nickname
    }
}
