//
//  TopBarView.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import UIKit
import Common

final class TopBarView: UIView {
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnX.image, for: .normal)
        return button
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록", for: .normal)
        button.setTitleColor(CommonAsset.Colors.gray03.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 16).font
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        addSubviews(cancelButton, uploadButton)
        
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 26),
            uploadButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            uploadButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            uploadButton.heightAnchor.constraint(equalToConstant: 37),
            uploadButton.widthAnchor.constraint(equalToConstant: 65)
        ])
    }
}

extension TopBarView {
    func setEnableUploadButton() {
        uploadButton.setTitleColor(.white, for: .normal)
        uploadButton.backgroundColor = .black
        uploadButton.layer.cornerRadius = 18
    }
    
    func addTargetCancelButton(_ target: Any?, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func addTargetUploadButton(_ target: Any?, action: Selector) {
        uploadButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
