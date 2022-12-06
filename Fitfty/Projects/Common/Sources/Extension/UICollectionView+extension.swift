//
//  UICollectionView+extension.swift
//  Common
//
//  Created by Ari on 2022/12/05.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

public extension UICollectionView {

    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let reuseIdentifier = cellClass.className
        register(cellClass, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(_ cellClass: T.Type, forSupplementaryViewOfKind elementKind: String) {
        let reuseIdentifier = cellClass.className
        register(cellClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: reuseIdentifier)
    }

    func registerNib<T: UICollectionViewCell>(_ cellClass: T.Type) {
        let reuseIdentifier = cellClass.className
        register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: cellClass.className, for: indexPath) as? T
    }

}
