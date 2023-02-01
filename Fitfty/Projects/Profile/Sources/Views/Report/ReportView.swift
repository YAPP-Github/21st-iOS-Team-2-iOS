//
//  ReportView.swift
//  Profile
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class ReportView: UIStackView {
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnCheckBoxUnSelected.image, for: .normal)
        button.setImage(CommonAsset.Images.btnCheckBoxSelected.image, for: .selected)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setStackView()
        setConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStackView() {
        addArrangedSubviews(checkBoxButton, titleLabel)
        self.axis = .horizontal
        self.alignment = .leading
        self.distribution = .fill
        self.spacing = 12
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReportView)))
    }
    
    private func setConstraintsLayout() {
        NSLayoutConstraint.activate([
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

extension ReportView {
    
    @objc func didTapReportView(_ sender: UITapGestureRecognizer?) {
        if checkBoxButton.isSelected {
            checkBoxButton.isSelected = false
        } else {
            checkBoxButton.isSelected = true
        }
    }
   
}
