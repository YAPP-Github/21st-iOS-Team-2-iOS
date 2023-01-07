//
//  UploadCodyViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

final public class UploadCodyViewController: UIViewController {
    
    enum Section {
        
        case content
        case weatherTag
        case styleTag
        
        init?(index: Int) {
            switch index {
            case 0: self = .content
            case 1: self = .weatherTag
            case 2: self = .styleTag
            default: return nil
            }
        }
        
    }
    
    private var coordinator: UploadCodyCoordinatorInterface
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private let topBarView = TopBarView()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ContentCell.self)
        return collectionView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        setUpButtonAction()
        setUpDataSource()
        applySnapshot()
    }

    public init(coordinator: UploadCodyCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraintLayout() {
        view.addSubviews(topBarView, collectionView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBarView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            topBarView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                let section = Section(index: indexPath.section)
                switch section {
                case .content:
                    let cell = collectionView.dequeueReusableCell(ContentCell.self, for: indexPath)
                    return cell
                    
                case .weatherTag:
                    let cell = collectionView.dequeueReusableCell(ContentCell.self, for: indexPath)
                    return cell
                    
                case .styleTag:
                    let cell = collectionView.dequeueReusableCell(ContentCell.self, for: indexPath)
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
            })
       
        collectionView.dataSource = dataSource
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.content])
        snapshot.appendItems([UUID()])
        snapshot.appendSections([.weatherTag])
        snapshot.appendItems([UUID()])
        snapshot.appendSections([.styleTag])
        snapshot.appendItems([UUID()])
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(index: sectionNumber)
            switch section {
            case .content: return self?.contentSectionLayout()
            case .weatherTag: return self?.contentSectionLayout()
            case .styleTag: return self?.contentSectionLayout()
            default: return nil
            }
        }
    }
    
    private func contentSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func setUpButtonAction() {
        topBarView.addTargetCancelButton(self, action: #selector(didTapCancelButton))
        topBarView.addTargetUploadButton(self, action: #selector(didTapUploadButton))
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismissUploadCody(self)
    }
    
    @objc func didTapUploadButton(_ sender: UIButton) {
        topBarView.setEnableUploadButton()
    }
}
