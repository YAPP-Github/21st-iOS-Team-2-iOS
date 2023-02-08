//
//  FooterView.swift
//  MainFeed
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public final class FooterView: UICollectionReusableView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CommonAsset.Colors.gray01.color
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
