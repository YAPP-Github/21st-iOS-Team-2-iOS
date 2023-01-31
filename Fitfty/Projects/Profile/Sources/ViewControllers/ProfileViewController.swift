//
//  ProfileViewController.swift
//  Profile
//
//  Created by 임영선 on 2022/12/04.
//  Copyright © 2022 Fitfty. All rights reserved.
//

import UIKit
import Common

final public class ProfileViewController: UIViewController {
    
    enum Section: CaseIterable {
        case feed
    }
    private var coordinator: ProfileCoordinatorInterface
    private var profileType: ProfileType
    private var presentType: PresentType
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: postLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(FeedImageCell.self,
                                forCellWithReuseIdentifier: FeedImageCell.className)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = CommonAsset.Colors.gray01.color
        return view
    }()
    
    private let miniProfileView = MiniProfileView(imageSize: 48, frame: .zero)
    
    private var headerHeight: CGFloat {
        switch presentType {
        case .main:
            return 196
        case .tab:
            return 283
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        setNavigationBar()
    }
    
    public init(coordinator: ProfileCoordinatorInterface, profileType: ProfileType, presentType: PresentType) {
        self.coordinator = coordinator
        self.profileType = profileType
        self.presentType = presentType
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpConstraintLayout()
        setUpDataSource()
        registerHeaderView()
        applySnapshot()
        setMiniProfileView(isHidden: true)
        miniProfileView.setUp(image: CommonAsset.Images.profileSample.image, nickname: "iosLover")
    }
    
    @objc func didTapMoreVerticalButton(_ sender: Any?) {
        coordinator.showBottomSheet()
    }
    
}

private extension ProfileViewController {
    
    func setUpConstraintLayout() {
        view.addSubviews(collectionView, miniProfileView, seperatorView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            miniProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            miniProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            miniProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            miniProfileView.heightAnchor.constraint(equalToConstant: 66),
            
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: miniProfileView.bottomAnchor)
        ])
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.topItem?.title = ""
        switch presentType {
        case .tab:
            navigationController?.navigationBar.isHidden = true
        case .main:
            navigationController?.navigationBar.isHidden = false
        }
        
        switch profileType {
        case .userProfile:
            navigationItem.rightBarButtonItem =
            UIBarButtonItem(
                image: CommonAsset.Images.btnMoreVertical.image,
                style: .plain,
                target: self,
                action: #selector(didTapMoreVerticalButton)
            )
            navigationItem.rightBarButtonItem?.tintColor = .black
        case .myProfile:
            break
        }
    }
    
    func registerHeaderView() {
        switch presentType {
        case .main:
            collectionView.register(UserProfileHeaderView.self,
                                    forSupplementaryViewOfKind: UserProfileHeaderView.className)
        case .tab:
            collectionView.register(MyProfileHeaderView.self,
                                    forSupplementaryViewOfKind: MyProfileHeaderView.className)
        }
    }
    
    func setMiniProfileView(isHidden: Bool) {
        miniProfileView.isHidden = isHidden
        seperatorView.isHidden = isHidden
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
        
        dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            switch self.presentType {
            case .main:
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: UserProfileHeaderView.className,
                    for: indexPath) as? UserProfileHeaderView else {
                    return UICollectionReusableView()
                }
                supplementaryView.profileView.setUp(nickname: "useriosLover", content: "안녕하세용!")
                return supplementaryView
                
            case .tab:
                guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MyProfileHeaderView.className,
                    for: indexPath) as? MyProfileHeaderView else {
                    return UICollectionReusableView()
                }
                supplementaryView.profileView.setUp(nickname: "myiosLover", content: "안녕하세용!")
                return supplementaryView
            }
        }
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.feed])
        snapshot.appendItems(Array(0..<10).map {_ in UUID() })
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func postLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 27, leading: 12, bottom: 5, trailing: 12)
        
        switch presentType {
        case .main:
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .absolute(UIScreen.main.bounds.width),
                        heightDimension: .estimated(headerHeight)
                    ),
                    elementKind: UserProfileHeaderView.className,
                    alignment: .top
                )
            ]
            
        case .tab:
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(
                        widthDimension: .absolute(UIScreen.main.bounds.width),
                        heightDimension: .estimated(headerHeight)
                    ),
                    elementKind: MyProfileHeaderView.className,
                    alignment: .top
                )
            ]
        }
       
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension ProfileViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.showPost(profileType: profileType)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= headerHeight {
            setMiniProfileView(isHidden: false)
        } else {
            setMiniProfileView(isHidden: true)
        }
    }
    
}
