//
//  ProfileViewController.swift
//  Profile
//
//  Created by 임영선 on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit

final public class MyProfileViewController: UIViewController {
    
    enum Section: CaseIterable {
        case feed
    }
    private var coordinator: MyProfileCoordinatorInterface
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
 
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        setUpCollectionView()
        setUpDataSource()
        applySnapshot()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    public init(coordinator: MyProfileCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MyProfileViewController {
    func setUpConstraintLayout() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.register(FeedImageCell.self,
                                forCellWithReuseIdentifier: FeedImageCell.className)
        collectionView.register(MyProfileHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MyProfileHeaderView.className)
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, _) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FeedImageCell.className,
                    for: indexPath) as? FeedImageCell else {
                    return UICollectionViewCell()
                }
                return cell
            })
        
        dataSource?.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyProfileHeaderView.className,
                for: indexPath) as? MyProfileHeaderView else {
                return UICollectionReusableView()
            }
            supplementaryView.profileView.setUp(nickname: "iosLover", content: "안녕하세용!")
            supplementaryView.menuView.setUp(count: "12")
            supplementaryView.setButtonTarget(target: self, action: #selector(self?.didTapSettingButton(_:)))
            return supplementaryView
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(Array(0..<10).map {_ in UUID() })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func didTapSettingButton(_ sender: UIButton) {
        coordinator.showSetting()
    }
}

extension MyProfileViewController: UICollectionViewDelegateFlowLayout {
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
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 350)
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
        coordinator.showPost()
    }
    
}
