//
//  FeedSettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class FeedSettingViewController: UIViewController {
    
    private weak var coordinator: FeedSettingCoordinatorInterface?
    private var viewModel: FeedSettingViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<FeedSettingSection, FeedSetting>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: FeedSettingCoordinatorInterface, viewModel: FeedSettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator?.dismiss()
    }
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "핏프티 피드 정보 설정", isChevronButtonHidden: true)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return barView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(FeedSettingCell.self)
        collectionView.register(FeedSettingHeaderView.self, forSupplementaryViewOfKind: FeedSettingHeaderView.className)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private lazy var cancelButton: FitftyButton = {
        let button = FitftyButton(style: .enabled, title: "닫기")
        button.setButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        return button
    }()
}

private extension FeedSettingViewController {
    
    func setUp() {
        setUpLayout()
        setUpDataSource()
        applySnapshot()
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(navigationBarView, collectionView, cancelButton)
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            collectionView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 235),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            cancelButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    @objc func didTapCancelButton(_ sender: UITapGestureRecognizer) {
        coordinator?.dismiss()
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = FeedSettingSection(index: sectionNumber)
            switch section {
            case .genders, .tags: return self?.settingsLayout()
            default: return nil
            }
        }
    }
    
    func settingsLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(86),
            heightDimension: .absolute(43)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 8, leading: 20, bottom: 28, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 8

        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(22)
                ),
                elementKind: FeedSettingHeaderView.className, alignment: .top
            )
        ]
        
        return section
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FeedSettingSection, FeedSetting>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let section = FeedSettingSection(index: indexPath.section)
                switch section {
                case .genders, .tags:
                    guard let cell = collectionView.dequeueReusableCell(FeedSettingCell.self, for: indexPath) else {
                        return UICollectionViewCell()
                    }
                    cell.setUp(title: item.title, isSelected: [false, true].randomElement() ?? false)
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
            })
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let section = FeedSettingSection(index: indexPath.section)
            switch elementKind {
            case FeedSettingHeaderView.className:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: FeedSettingHeaderView.className,
                    for: indexPath
                ) as? FeedSettingHeaderView
                headerView?.setUp(title: section?.title ?? "")
                return headerView
                
            default: return UICollectionReusableView()
            }
            
        }
        collectionView.dataSource = dataSource
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<FeedSettingSection, FeedSetting>()
        snapshot.appendSections([.genders])
        snapshot.appendItems(FeedSetting.genders())
        snapshot.appendSections([.tags])
        snapshot.appendItems(FeedSetting.tags())
        dataSource?.apply(snapshot)
    }
    
}

extension FeedSettingViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FeedSettingCell
        cell?.toggle()
    }
}
