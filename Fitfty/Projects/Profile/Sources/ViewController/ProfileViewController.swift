//
//  ProfileViewController.swift
//  Profile
//
//  Created by 임영선 on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Auth

final public class ProfileViewController: UIViewController {
    
    enum Section: CaseIterable {
        case feed
    }
    
    public weak var coordinator: AuthCoordinatorInterface?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
 
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        setUpDataSource()
        applySnapshot()
    }

}

private extension ProfileViewController {
    func setUpConstraintLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setUpDataSource() {
        collectionView.delegate = self
        collectionView.register(FeedImageCell.self,
                                forCellWithReuseIdentifier: FeedImageCell.identifier)
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeedImageCell.identifier,
                    for: indexPath) as? FeedImageCell else {
                    return UICollectionViewCell()
                }
                return cell
            })
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(Array(0..<10).map {_ in UUID() })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width) / 2 - 28
        let height = width * 1.157
        return CGSize(width: width, height: height)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
    }
    
}
