//
//  ReportView.swift
//  Profile
//
//  Created by 임영선 on 2023/01/31.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class ReportCell: UITableViewCell {
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnCheckBoxUnSelected.image, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        return label
    }()
    
    private lazy var stackView:  UIStackView = {
        let stackView = UIStackView(
            axis: .horizontal,
            alignment: .leading,
            distribution: .fill,
            spacing: 12
        )
        stackView.addArrangedSubviews(checkBoxButton, titleLabel)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
 
}

extension ReportCell {
    
    func setUp(title: String, isSelected: Bool) {
        if isSelected {
            checkBoxButton.setImage(CommonAsset.Images.btnCheckBoxSelected.image, for: .normal)
        } else {
            checkBoxButton.setImage(CommonAsset.Images.btnCheckBoxUnSelected.image, for: .normal)
        }
        titleLabel.text = title
    }
    
}
