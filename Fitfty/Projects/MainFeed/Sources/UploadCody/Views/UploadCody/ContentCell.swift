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
        button.addTarget(self, action: #selector(didTapBackgroundButton(_:)), for: .touchUpInside)
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
    
    private lazy var codyImageView: UIImageView = {
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
        textView.returnKeyType = .done
        textView.delegate = self
        return textView
    }()
    
    private lazy var guidanceLabel: UILabel = {
        let label = UILabel()
        label.font = FitftyFont.appleSDMedium(size: 16).font
        label.textColor = CommonAsset.Colors.gray02.color
        label.text = "사진은 수정이 불가능해요.\n사진 수정을 원한다면 새로운 게시글로 올려보세요."
        label.numberOfLines = 0
        label.setTextWithLineHeight(lineHeight: 22)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func prepareForReuse() {
        contentTextView.text = "100자 이내로 설명을 남길 수 있어요."
        contentTextView.textColor = CommonAsset.Colors.gray04.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraintsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintsLayout() {
        contentView.addSubviews(codyImageView, backgroundButton, uploadPhotoButton, contentTextView, guidanceLabel)
        
        NSLayoutConstraint.activate([
            backgroundButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            backgroundButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width*0.936),
            
            codyImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            codyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            codyImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            codyImageView.heightAnchor.constraint(equalTo: backgroundButton.heightAnchor),
            
            uploadPhotoButton.centerXAnchor.constraint(equalTo: backgroundButton.centerXAnchor),
            uploadPhotoButton.centerYAnchor.constraint(equalTo: backgroundButton.centerYAnchor),
            uploadPhotoButton.heightAnchor.constraint(equalToConstant: 40),
            uploadPhotoButton.widthAnchor.constraint(equalToConstant: 138),
            
            contentTextView.topAnchor.constraint(equalTo: backgroundButton.bottomAnchor, constant: 20),
            contentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            
            guidanceLabel.centerXAnchor.constraint(equalTo: backgroundButton.centerXAnchor),
            guidanceLabel.centerYAnchor.constraint(equalTo: backgroundButton.centerYAnchor)
        ])
    }
    
    @objc func didTapBackgroundButton(_ sender: UIButton) {
        contentTextView.resignFirstResponder()
    }
}

extension ContentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: .scrollToBottom, object: nil)
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        NotificationCenter.default.post(name: .scrollToTop, object: nil)
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
    
    public func setUp(codyImage: UIImage, content: String) {
        codyImageView.image = codyImage
        contentTextView.text = content
        contentTextView.textColor = .black
    }
    
    public func setActionUploadPhotoButton(_ target: Any?, action: Selector) {
        uploadPhotoButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    public func setDisableEditting() {
        backgroundButton.backgroundColor = .black
        backgroundButton.alpha = 0.5
        uploadPhotoButton.isHidden = true
        guidanceLabel.isHidden = false
    }
}
