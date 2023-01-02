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
        button.addTarget(self, action: #selector(didTapMyFitftyButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var myFitftyTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 15).font
        button.setTitleColor(.black, for: .normal)
        button.setTitle("내 핏프티", for: .normal)
        button.addTarget(self, action: #selector(didTapMyFitftyButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var myFitftyCountButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FitftyFont.SFProDisplaySemibold(size: 13).font
        button.setTitleColor(UIColor(red: 0.22, green: 0.675, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(didTapMyFitftyButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 0, right: 0)
        return button
    }()
    
    private lazy var bookmarkIconButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnBookmarkUnselected.image, for: .normal)
        button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var bookmarkTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 15).font
        button.setTitleColor(.black, for: .normal)
        button.setTitle("즐겨찾기", for: .normal)
        button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var barView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1)
        return view
    }()
    
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
        addSubviews(myFitftyIconButton, myFitftyTextButton, myFitftyCountButton,
                    bookmarkIconButton, bookmarkTextButton, barView)
       
        NSLayoutConstraint.activate([
            barView.widthAnchor.constraint(equalToConstant: 1),
            barView.heightAnchor.constraint(equalToConstant: 72),
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            myFitftyIconButton.rightAnchor.constraint(equalTo: barView.leftAnchor, constant: -65),
            myFitftyIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            myFitftyCountButton.rightAnchor.constraint(equalTo: barView.leftAnchor, constant: -48),
            myFitftyCountButton.topAnchor.constraint(equalTo: myFitftyIconButton.bottomAnchor, constant: 14),
            
            myFitftyTextButton.rightAnchor.constraint(equalTo: myFitftyCountButton.leftAnchor, constant: -2),
            myFitftyTextButton.topAnchor.constraint(equalTo: myFitftyIconButton.bottomAnchor, constant: 14),
            
            bookmarkIconButton.leftAnchor.constraint(equalTo: barView.rightAnchor, constant: 65),
            bookmarkIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            bookmarkTextButton.leftAnchor.constraint(equalTo: barView.rightAnchor, constant: 48),
            bookmarkTextButton.topAnchor.constraint(equalTo: bookmarkIconButton.bottomAnchor, constant: 14)
        ])
    }
    
    @objc func didTapMyFitftyButton(_ sender: UIButton) {
        menuState = .myFitfty
    }
    
    @objc func didTapBookmarkButton(_ sender: UIButton) {
        menuState = .bookmark
    }
}

extension MenuView {
    func setUp(count: String) {
        myFitftyCountButton.setTitle(count, for: .normal)
    }
}
