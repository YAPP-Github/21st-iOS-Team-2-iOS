//
//  EmptyView.swift
//  Profile
//
//  Created by 임영선 on 2023/02/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import UIKit
import Common

final class EmptyView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.textColor = CommonAsset.Colors.gray04.color
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(CommonAsset.Colors.gray05.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 13).font
        button.layer.cornerRadius = 17
        button.layer.borderColor = CommonAsset.Colors.gray01.color.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraintsLayout() {
        addSubviews(titleLabel, button)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 140),
            button.heightAnchor.constraint(equalToConstant: 34),
            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}

extension EmptyView {
    
    func setUp(_ menuType: MenuType) {
        switch menuType {
        case .myFitfty:
            titleLabel.text = "아직 등록한 게시글이 없어요.\n지금 날씨에 맞는 코디를 올려보세요."
            titleLabel.setTextWithLineHeight(lineHeight: 21)
            titleLabel.textAlignment = .center
            button.setTitle("새 핏프티 등록", for: .normal)
        case .bookmark:
            titleLabel.text = "아직 저장한 게시글이 없어요.\n지금 날씨에 맞는 코디를 찾아보세요."
            titleLabel.setTextWithLineHeight(lineHeight: 21)
            titleLabel.textAlignment = .center
            button.setTitle("피드 보러 가기", for: .normal)
        }
    }
    
    func setButtonAction(_ target: Any?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
