//
//  UserProfileHeaderView.swift
//  Profile
//
//  Created by 임영선 on 2023/01/18.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final class UserProfileHeaderView: UICollectionReusableView {

    let profileView = ProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: topAnchor, constant: 29),
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
