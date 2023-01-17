//
//  HeaderView.swift
//  Common
//
//  Created by 임영선 on 2023/01/10.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class HeaderView: UICollectionReusableView {
        
    private lazy var largeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private lazy var smallTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension HeaderView {
    public func setUp(
        largeTitle: String,
        smallTitle: String?,
        largeTitleFont: UIFont,
        smallTitleFont: UIFont?,
        smallTitleColor: UIColor?,
        largeTitleTopAnchorConstant: CGFloat,
        smallTitleTopAchorConstant: CGFloat
    ) {

        largeTitleLabel.text = largeTitle
        smallTitleLabel.text = smallTitle
        largeTitleLabel.font = largeTitleFont
        smallTitleLabel.font = smallTitleFont
        smallTitleLabel.textColor = smallTitleColor
        
        addSubviews(stackView)
        stackView.addArrangedSubviews(largeTitleLabel, smallTitleLabel)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: largeTitleTopAnchorConstant),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        stackView.setCustomSpacing(smallTitleTopAchorConstant, after: largeTitleLabel)
    }
}
