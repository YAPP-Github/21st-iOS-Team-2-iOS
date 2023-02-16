//
//  ReportListCell.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final class ReportListCell: UITableViewCell {
    
    private lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(CommonAsset.Images.btnCheckBoxUnSelected.image, for: .normal)
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
        return button
    }()
    
    private lazy var accountLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.text = "dud@naver.com"
        return label
    }()
    
    private lazy var detailReportLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.text = "불쾌"
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        label.text = "13"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(checkBoxButton, accountLabel, detailReportLabel, countLabel)
        NSLayoutConstraint.activate([
            checkBoxButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20),
            checkBoxButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            accountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountLabel.widthAnchor.constraint(equalToConstant: 120),
            
            detailReportLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailReportLabel.leadingAnchor.constraint(equalTo: accountLabel.trailingAnchor, constant: 10),
            detailReportLabel.widthAnchor.constraint(equalToConstant: 120),
            
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: detailReportLabel.trailingAnchor, constant: 10),
            countLabel.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func didTapCheckbox(_ sender: Any?) {
        if !checkBoxButton.isSelected {
            checkBoxButton.setImage(CommonAsset.Images.btnCheckBoxSelected.image, for: .normal)
        } else {
            checkBoxButton.setImage(CommonAsset.Images.btnCheckBoxUnSelected.image, for: .normal)
        }
    }
 
}

extension ReportListCell {
    
    func setUp(account: String, detailReport: String, count: String) {
        accountLabel.text = account
        detailReportLabel.text = detailReport
        countLabel.text = count
    }
    
}
