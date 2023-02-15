//
//  MenuView.swift
//  Profile
//
//  Created by 임영선 on 2022/12/09.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final class MenuView: UIView {
    
    enum MenuState {
        case myFitfty
        case bookmark
    }

    private lazy var myFitftyIconButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnCodySelected.image, for: .normal)
        return button
    }()
    
    private lazy var bookmarkIconButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnBookmarkUnselected.image, for: .normal)
        return button
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        return view
    }()
    
    private let myFitftyMenuView = UIView()
    private let bookmarkMenuView = UIView()
    
    private var menuState: MenuState = .myFitfty {
        didSet {
            switch menuState {
            case .myFitfty:
                myFitftyIconButton.setImage(CommonAsset.Images.btnCodySelected.image, for: .normal)
                bookmarkIconButton.setImage(CommonAsset.Images.btnBookmarkUnselected.image, for: .normal)
            case .bookmark:
                myFitftyIconButton.setImage(CommonAsset.Images.btnCodyUnselected.image, for: .normal)
                bookmarkIconButton.setImage(CommonAsset.Images.btnBookmarkSelected.image, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        addSubviews(barView, myFitftyMenuView, bookmarkMenuView, myFitftyIconButton, bookmarkIconButton)
       
        NSLayoutConstraint.activate([
            barView.widthAnchor.constraint(equalToConstant: 1),
            barView.topAnchor.constraint(equalTo: topAnchor),
            barView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            myFitftyMenuView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            myFitftyMenuView.trailingAnchor.constraint(equalTo: barView.leadingAnchor),
            myFitftyMenuView.topAnchor.constraint(equalTo: topAnchor),
            myFitftyMenuView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            bookmarkMenuView.leadingAnchor.constraint(equalTo: barView.trailingAnchor),
            bookmarkMenuView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            bookmarkMenuView.topAnchor.constraint(equalTo: topAnchor),
            bookmarkMenuView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            myFitftyIconButton.trailingAnchor.constraint(equalTo: barView.leadingAnchor, constant: -65),
            myFitftyIconButton.centerYAnchor.constraint(equalTo: myFitftyMenuView.centerYAnchor),
            
            bookmarkIconButton.leadingAnchor.constraint(equalTo: barView.trailingAnchor, constant: 65),
            bookmarkIconButton.centerYAnchor.constraint(equalTo: bookmarkMenuView.centerYAnchor)
        ])
    }
    
}

extension MenuView {
    
    func setMyFitftyButtonTarget(_ target: Any?, action: Selector) {
        myFitftyIconButton.addTarget(target, action: action, for: .touchUpInside)
        myFitftyMenuView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    func setBookmarkButtonTarget(_ target: Any?, action: Selector) {
        bookmarkIconButton.addTarget(target, action: action, for: .touchUpInside)
        bookmarkMenuView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: action))
    }
    
    func setMenuState(_ menuType: MenuType) {
        switch menuType {
        case .myFitfty:
            menuState = .myFitfty
        case .bookmark:
            menuState = .bookmark
        }
    }
    
}
