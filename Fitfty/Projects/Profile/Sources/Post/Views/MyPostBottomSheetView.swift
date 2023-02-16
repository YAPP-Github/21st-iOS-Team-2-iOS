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
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.gray07.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton()
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
        self.distribution = .fill
        self.spacing = 24
        addArrangedSubviews(firstButton, seperatorView, secondButton)
        NSLayoutConstraint.activate([
            seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

extension MyPostBottomSheetView {
    
    func setUpMyPost() {
        firstButton.setTitle("게시글 수정", for: .normal)
        secondButton.setTitle("게시글 삭제", for: .normal)
    }
    
    func setUpUserPost() {
        firstButton.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        firstButton.setTitle("계정 신고", for: .normal)
        secondButton.setTitle("게시글 신고", for: .normal)
    }
    
    func setActionFirstButton(_ target: Any?, action: Selector) {
        firstButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setActionSecondButton( _ target: Any?, action: Selector) {
        secondButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}

