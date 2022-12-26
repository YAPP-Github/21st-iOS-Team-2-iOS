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
        case cody
        case bookmark
    }

    private lazy var codyIconButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnCodySelected.image, for: .normal)
        button.addTarget(self, action: #selector(didTapCodyButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var codyTextButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 15).font
        button.setTitleColor(.black, for: .normal)
        button.setTitle("나의 코디", for: .normal)
        button.addTarget(self, action: #selector(didTapCodyButton), for: .touchUpInside)
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
    
    private var menuState: MenuState = .cody {
        didSet {
            switch menuState {
            case .cody:
                codyIconButton.setImage(CommonAsset.Images.btnCodySelected.image, for: .normal)
                bookmarkIconButton.setImage(CommonAsset.Images.btnBookmarkUnselected.image, for: .normal)
            case .bookmark:
                codyIconButton.setImage(CommonAsset.Images.btnCodyUnselected.image, for: .normal)
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
        [codyIconButton, codyTextButton, bookmarkIconButton, bookmarkTextButton, barView].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            barView.widthAnchor.constraint(equalToConstant: 1),
            barView.heightAnchor.constraint(equalToConstant: 72),
            barView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            codyIconButton.rightAnchor.constraint(equalTo: barView.leftAnchor, constant: -65),
            codyIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            codyTextButton.rightAnchor.constraint(equalTo: barView.leftAnchor, constant: -48),
            codyTextButton.topAnchor.constraint(equalTo: codyIconButton.bottomAnchor, constant: 14),
            bookmarkIconButton.leftAnchor.constraint(equalTo: barView.rightAnchor, constant: 65),
            
            bookmarkIconButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            bookmarkTextButton.leftAnchor.constraint(equalTo: barView.rightAnchor, constant: 48),
            bookmarkTextButton.topAnchor.constraint(equalTo: bookmarkIconButton.bottomAnchor, constant: 14)
        ])
    }
    
    @objc func didTapCodyButton(_ sender: UIButton) {
        menuState = .cody
    }
    
    @objc func didTapBookmarkButton(_ sender: UIButton) {
        menuState = .bookmark
    }
}
