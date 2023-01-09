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
    
    private let styleTagItems = ["포멀", "캐주얼"]
    
    private let weatherTagItems = ["❄️ 한파", "🌨 추운날", "🍂 쌀쌀한 날", "☀️ 따듯한 날", "🔥 더운날"]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ContentCell.self)
        collectionView.register(StyleTagCell.self)
        collectionView.register(WeatherTagCell.self)
        collectionView.register(StyleTagHeaderView.self, forSupplementaryViewOfKind: StyleTagHeaderView.className)
        collectionView.register(WeatherTagHeaderView.self, forSupplementaryViewOfKind: WeatherTagHeaderView.className)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.delegate = self
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
                    let cell = collectionView.dequeueReusableCell(WeatherTagCell.self, for: indexPath)
                    cell?.setUp(text: self.weatherTagItems[indexPath.item])
                    return cell
                    
                case .styleTag:
                    let cell = collectionView.dequeueReusableCell(StyleTagCell.self, for: indexPath)
                    cell?.setUp(text: self.styleTagItems[indexPath.item])
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
            })
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case StyleTagHeaderView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: StyleTagHeaderView.className,
                    for: indexPath
                )
                
            case WeatherTagHeaderView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: WeatherTagHeaderView.className,
                    for: indexPath
                )
            
            case FooterView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: FooterView.className,
                    for: indexPath
                )
                
            default:
                return UICollectionReusableView()
            }
        }
        
        collectionView.dataSource = dataSource
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.content])
        snapshot.appendItems([UUID()])
        snapshot.appendSections([.weatherTag])
        snapshot.appendItems(Array(0..<weatherTagItems.count).map {_ in UUID() })
        snapshot.appendSections([.styleTag])
        snapshot.appendItems(Array(0..<styleTagItems.count).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(index: sectionNumber)
            switch section {
            case .content: return self?.contentSectionLayout()
            case .weatherTag: return self?.weatherTagSectionLayout()
            case .styleTag: return self?.styleTagSectionLayout()
            default: return nil
            }
        }
    }
    
    private func contentSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(550)
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
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width) ,
                    heightDimension: .absolute(8)
                ),
                elementKind: FooterView.className,
                alignment: .bottom
            )
        ]
        
        return section
    }
    
    private func styleTagSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(43)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
            
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        item.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width-40),
                    heightDimension: .absolute(20)
                ),
                elementKind: StyleTagHeaderView.className, alignment: .top)
        ]
        return section
    }
    
    private func weatherTagSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
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
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width-40),
                    heightDimension: .estimated(40)
                ),
                elementKind: WeatherTagHeaderView.className, alignment: .top),
            
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width-40),
                    heightDimension: .absolute(1)
                ),
                elementKind: FooterView.className, alignment: .bottom)
        ]
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

extension UploadCodyViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(index: indexPath.section)
        switch section {
        case .weatherTag:
            break
        case .styleTag:
            let cell = collectionView.dequeueReusableCell(StyleTagCell.self, for: indexPath)
            for item in 0..<styleTagItems.count {
                item == indexPath.row ? cell?.setSelectedButton(isSelected: true) : cell?.setSelectedButton(isSelected: false)
            }
        default:
            break
        }
        
    }
}
