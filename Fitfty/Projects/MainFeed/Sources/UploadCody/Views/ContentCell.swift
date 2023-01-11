//
//  ContentCell.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class ContentCell: UICollectionViewCell {
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CommonAsset.Colors.gray01.color
        button.setTitle("", for: .normal)
        return button
    }()
    
    private lazy var uploadPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnInstagram.image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        button.setTitle("사진 업로드", for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 15).font
        button.setTitleColor(CommonAsset.Colors.gray06.color, for: .normal)
        button.layer.borderColor = CommonAsset.Colors.gray03.color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let textViewPlaceHolder = "100자 이내로 설명을 남길 수 있어요."
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceHolder
        textView.font = FitftyFont.appleSDMedium(size: 16).font
        textView.textColor = CommonAsset.Colors.gray04.color
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintsLayout() {
        contentView.addSubviews(backgroundButton, uploadPhotoButton, imageView, contentTextView)
        
        NSLayoutConstraint.activate([
            
            backgroundButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            backgroundButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backgroundButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            backgroundButton.heightAnchor.constraint(equalToConstant: 350),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 350),
            
            uploadPhotoButton.centerXAnchor.constraint(equalTo: backgroundButton.centerXAnchor),
            uploadPhotoButton.centerYAnchor.constraint(equalTo: backgroundButton.centerYAnchor),
            uploadPhotoButton.heightAnchor.constraint(equalToConstant: 40),
            uploadPhotoButton.widthAnchor.constraint(equalToConstant: 138),
            
            contentTextView.topAnchor.constraint(equalTo: backgroundButton.bottomAnchor, constant: 20),
            contentTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            contentTextView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
    }
}

extension ContentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = CommonAsset.Colors.gray04.color
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

extension ContentCell {
    public func setActionUploadPhotoButton(_ target: Any?, action: Selector) {
        backgroundButton.addTarget(target, action: action, for: .touchUpInside)
        uploadPhotoButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
