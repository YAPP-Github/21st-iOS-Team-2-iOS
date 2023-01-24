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
    
    private lazy var bookmarkIconButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnBookmarkUnselected.image, for: .normal)
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
        addSubviews(myFitftyIconButton, bookmarkIconButton, barView)
       
        NSLayoutConstraint.activate([
            barView.widthAnchor.constraint(equalToConstant: 1),
            barView.heightAnchor.constraint(equalToConstant: 32),
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            myFitftyIconButton.trailingAnchor.constraint(equalTo: barView.leadingAnchor, constant: -65),
            myFitftyIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            bookmarkIconButton.leadingAnchor.constraint(equalTo: barView.trailingAnchor, constant: 65),
            bookmarkIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10)
        ])
    }
    
    @objc func didTapMyFitftyButton(_ sender: UIButton) {
        menuState = .myFitfty
    }
    
    @objc func didTapBookmarkButton(_ sender: UIButton) {
        menuState = .bookmark
    }
}
