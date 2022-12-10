//
//  MainViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Common

public final class MainViewController: UIViewController {
    
    enum Section {
        case weather
        case style
        case cody
    }
    
    public var coordinator: MainCoordinatorInterface?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private lazy var collectionView: UICollectionView = {
        let colletionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        colletionView.register(WeatherCell.self)
        colletionView.register(StyleCell.self)
        colletionView.register(CodyCell.self)
        colletionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        colletionView.register(HeaderView.self, forSupplementaryViewOfKind: HeaderView.className)
        colletionView.register(WeatherInfoHeaderView.self, forSupplementaryViewOfKind: WeatherInfoHeaderView.className)
        return colletionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpNavigationBar()
        setUpDataSource()
        setUpCollectionView()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpNavigationBar() {
        let locationView = LocationView("성북구 정릉동")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationView)
    }
    
    private func setUpLayout() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                switch indexPath.section {
                case 0:
                    let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)
                    return cell
                case 1:
                    let cell = collectionView.dequeueReusableCell(StyleCell.self, for: indexPath)
                    cell?.setUp(text: ["포멀", "캐주얼", "미니멀"].randomElement()!)
                    return cell
                case 2:
                    let cell = collectionView.dequeueReusableCell(CodyCell.self, for: indexPath)
                    return cell
                default: return UICollectionViewCell()
                }
            })
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            switch elementKind {
            case HeaderView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HeaderView.className,
                    for: indexPath
                )
            case UICollectionView.elementKindSectionFooter:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: FooterView.className,
                    for: indexPath
                )
            case WeatherInfoHeaderView.className:
                let reusableView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: WeatherInfoHeaderView.className,
                    for: indexPath
                ) as? WeatherInfoHeaderView
                reusableView?.setUp(temp: 12, condition: "구름 많음", minimum: 12, maximum: 12)
                return reusableView
            default: return UICollectionReusableView()
            }
            
        }
        collectionView.dataSource = dataSource
    }
    
    private func setUpCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.weather])
        snapshot.appendItems(Array(0...23).map { _ in UUID() })
        snapshot.appendSections([.style])
        snapshot.appendItems(Array(0...6).map { _ in UUID() })
        snapshot.appendSections([.cody])
        snapshot.appendItems(Array(0...10).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
            case 0: // 날씨 아이콘 섹션
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(74),
                    heightDimension: .absolute(72)
                )

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: layoutSize.widthDimension,
                    heightDimension: layoutSize.heightDimension
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [.init(layoutSize: layoutSize)]
                )

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: .zero, leading: 10, bottom: 28, trailing: .zero)
                section.orthogonalScrollingBehavior = .continuous
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .absolute(UIScreen.main.bounds.width),
                            heightDimension: .absolute(80)
                        ),
                        elementKind: WeatherInfoHeaderView.className, alignment: .top),
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .absolute(UIScreen.main.bounds.width),
                            heightDimension: .absolute(8)
                        ),
                        elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                ]
                return section
            case 1: // 스타일 태그 섹션
                
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(100),
                    heightDimension: .absolute(32)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: layoutSize.widthDimension,
                        heightDimension: layoutSize.heightDimension
                    ),
                    subitems: [.init(layoutSize: layoutSize)]
                )
                group.interItemSpacing = .fixed(8)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: .zero, leading: 20, bottom: 20, trailing: 20)
                section.interGroupSpacing = 8
                section.orthogonalScrollingBehavior = .continuous
                
                section.boundarySupplementaryItems = [
                    NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: .init(
                            widthDimension: .absolute(UIScreen.main.bounds.width),
                            heightDimension: .absolute(50)
                        ),
                        elementKind: HeaderView.className, alignment: .top)
                ]
                return section
            case 2: // 코디 사진 섹션
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(300),
                    heightDimension: .absolute(336)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: layoutSize.widthDimension,
                        heightDimension: layoutSize.heightDimension
                    ),
                    subitems: [.init(layoutSize: layoutSize)]
                )
                group.interItemSpacing = .fixed(8)

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: .zero, leading: 20, bottom: .zero, trailing: 20)
                section.interGroupSpacing = 8
                section.orthogonalScrollingBehavior = .groupPaging
                
                return section
            default:
                return nil
            }
        }
    }
}
