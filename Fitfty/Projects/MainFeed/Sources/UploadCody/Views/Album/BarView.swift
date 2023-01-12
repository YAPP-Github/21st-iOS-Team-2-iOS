//
//  BarView.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/12.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class BarView: UIView {

    private lazy var albumStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        return stackView
    }()
    
    private lazy var albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 항목"
        label.font = FitftyFont.appleSDBold(size: 20).font
        return label
    }()
    
    private lazy var chevronButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = CommonAsset.Colors.gray08.color
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnGrayX.image, for: .normal)
        button.setPreferredSymbolConfiguration(.init(scale: .large), forImageIn: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(albumStackView, cancelButton)
        albumStackView.addArrangedSubviews(albumNameLabel, chevronButton)
        albumStackView.spacing = 10
        NSLayoutConstraint.activate([
            albumStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
        
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            cancelButton.widthAnchor.constraint(equalToConstant: 32),
            cancelButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc func didTapView(_ sender: Any?) {
        print("didTapView")
    }

}