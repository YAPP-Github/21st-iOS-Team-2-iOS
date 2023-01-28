//
//  SettingViewController.swift
//  Profile
//
//  Created by Ari on 2023/01/28.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common

public final class SettingViewController: UIViewController {
    
    private weak var coordinator: SettingCoordinatorInterface?
    private var viewModel: SettingViewModel
    
    private var dataSource: UICollectionViewDiffableDataSource<SettingViewSection, Setting>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: SettingCoordinatorInterface, viewModel: SettingViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(SettingCell.self)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        return collectionView
    }()
    
}

private extension SettingViewController {
    
    func setUp() {
        view.backgroundColor = .white
        setUpNavigationBar()
        setUpLayout()
        setUpDataSource()
        applySnapshot()
    }
    
    func setUpNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 28).font ?? UIFont.systemFont(ofSize: 28)]
        navigationItem.title = "설정"
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator?.finished()
    }
    
    func setUpLayout() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = SettingViewSection(index: sectionNumber)
            switch section {
            case .setting: return self?.settingsLayout()
            case .etc: return self?.etcLayout()
            default: return nil
            }
        }
    }
    
    func settingsLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(72)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(UIScreen.main.bounds.width),
                    heightDimension: .absolute(8)
                ),
                elementKind: FooterView.className, alignment: .bottom)
        ]
        return section
    }
    
    func etcLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(72)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        return section
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SettingViewSection, Setting>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(SettingCell.self, for: indexPath) else {
                    return UICollectionViewCell()
                }
                if collectionView.isLastItem(indexPath) {
                    cell.hiddenLine()
                }
                cell.setUp(item: item)
                return cell
            })
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case FooterView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: FooterView.className,
                    for: indexPath
                )
            default: return UICollectionReusableView()
            }
        }
        collectionView.dataSource = dataSource
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingViewSection, Setting>()
        snapshot.appendSections([.setting])
        snapshot.appendItems(Setting.settings())
        snapshot.appendSections([.etc])
        snapshot.appendItems(Setting.etc())
        dataSource?.apply(snapshot)
    }
}

extension SettingViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        switch item {
        case .profile:
            coordinator?.showProfileSetting()
        case .myInfo:
            coordinator?.showMyInfoSetting()
        case .feed:
            coordinator?.showFeedSetting()
        case .pushNoti:
            print(item)
        case .logout:
            print(item)
        case .membershipWithdrawal:
            print(item)
        }
    }
    
}
