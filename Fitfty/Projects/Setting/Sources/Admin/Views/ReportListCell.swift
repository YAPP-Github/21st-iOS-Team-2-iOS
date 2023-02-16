//
//  ReportListCell.swift
//  Setting
//
//  Created by 임영선 on 2023/02/16.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Kingfisher

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
        return label
    }()
    
    private lazy var detailReportLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = CommonAsset.Colors.gray06.color
        label.font = FitftyFont.appleSDMedium(size: 15).font
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraintsLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsLayout() {
        addSubviews(checkBoxButton, accountLabel, detailReportLabel, countLabel, postImageView)
        NSLayoutConstraint.activate([
            checkBoxButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 20),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 20),
            checkBoxButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            accountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            accountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            accountLabel.widthAnchor.constraint(equalToConstant: 150),
            
            detailReportLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailReportLabel.leadingAnchor.constraint(equalTo: accountLabel.trailingAnchor, constant: 10),
            detailReportLabel.widthAnchor.constraint(equalToConstant: 120),
            
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            countLabel.leadingAnchor.constraint(equalTo: detailReportLabel.trailingAnchor, constant: 10),
            countLabel.widthAnchor.constraint(equalToConstant: 10),
            
            postImageView.widthAnchor.constraint(equalToConstant: 100),
            postImageView.heightAnchor.constraint(equalToConstant: 100),
            postImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            postImageView.leadingAnchor.constraint(equalTo: leadingAnchor)
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
    
    func setUp(account: String, detailReport: String, count: String, filePath: String?) {
        accountLabel.text = account
        detailReportLabel.text = detailReport
        countLabel.text = count
        guard let filePath = filePath else {
            return
        }
        let url = URL(string: filePath)
        postImageView.kf.setImage(with: url)
    }
    
    func setReportType(_ reportType: ReportType) {
        switch reportType {
        case .userReport:
            postImageView.isHidden = true
        case.postReport:
            accountLabel.isHidden = true
        }
        
    }
   
}
