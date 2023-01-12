//
//  AlbumViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class AlbumViewController: UIViewController {
    
    enum Section: CaseIterable {
        case main
    }
    
    private let navigationBarView = BarView()
    private let bottomView = UIView()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("업로드", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: albumLayout())
        collectionView.register(AlbumCell.self)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setConstraintsLayout()
        setDataSource()
        applySanpshot()
    }
    
    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(navigationBarView, collectionView, bottomView, uploadButton)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBarView.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            
            collectionView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 152),
            
            uploadButton.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 20),
            uploadButton.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -20),
            uploadButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 32),
            uploadButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -56)
        ])
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                let cell = collectionView.dequeueReusableCell(AlbumCell.self, for: indexPath)
                return cell
            })
    }
    
    private func applySanpshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<25).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
    
    func albumLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}
