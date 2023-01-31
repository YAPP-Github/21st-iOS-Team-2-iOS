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
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
    }
}

extension ReportView {
    func setButton(isSelected: Bool) {
        checkBoxButton.isSelected = isSelected
    }
}
