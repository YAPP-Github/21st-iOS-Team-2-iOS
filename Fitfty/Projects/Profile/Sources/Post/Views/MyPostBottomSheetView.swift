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
    
    private lazy var thirdButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.gray07.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 18).font
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private lazy var seperatorView1: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        return view
    }()
    
    private lazy var seperatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addArrangedSubviews(firstButton, seperatorView1, secondButton)
        NSLayoutConstraint.activate([
            seperatorView1.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setStackView() {
        self.axis = .vertical
        self.distribution = .fill
        self.spacing = 24
    }
    
}

extension MyPostBottomSheetView {
    
    func setUpMyPost() {
        firstButton.setTitle("게시글 수정", for: .normal)
        secondButton.setTitle("게시글 삭제", for: .normal)
        setConstraintsLayout()
    }
    
    func setUpUserPost() {
        firstButton.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        firstButton.setTitle("계정 신고", for: .normal)
        secondButton.setTitle("게시글 신고", for: .normal)
        thirdButton.setTitle("이 게시글 가리기", for: .normal)
        addArrangedSubviews(firstButton, seperatorView1, secondButton, seperatorView2, thirdButton)
        NSLayoutConstraint.activate([
            seperatorView1.heightAnchor.constraint(equalToConstant: 1),
            seperatorView2.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setUpUserProfile() {
        firstButton.setTitleColor(CommonAsset.Colors.error.color, for: .normal)
        secondButton.setTitleColor(CommonAsset.Colors.gray07.color, for: .normal)
        firstButton.setTitle("계정 신고", for: .normal)
        secondButton.setTitle("이 계정 가리기", for: .normal)
        setConstraintsLayout()
    }
    
    func setActionFirstButton(_ target: Any?, action: Selector) {
        firstButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setActionSecondButton( _ target: Any?, action: Selector) {
        secondButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func setActionThirdButton( _ target: Any?, action: Selector) {
        thirdButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
