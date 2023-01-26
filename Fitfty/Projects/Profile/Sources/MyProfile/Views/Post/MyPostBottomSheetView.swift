//
//  MyPostBottomSheetView.swift
//  Profile
//
//  Created by 임영선 on 2023/01/26.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class MyPostBottomSheetView: UIStackView {
    
    private lazy var modifyButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시물 수정", for: .normal)
        button.setTitleColor(CommonAsset.Colors.gray07.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("게시물 삭제", for: .normal)
        button.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        self.axis = .vertical
        self.distribution = .equalSpacing
        addArrangedSubviews(modifyButton, seperatorView, deleteButton)
        NSLayoutConstraint.activate([
            seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
