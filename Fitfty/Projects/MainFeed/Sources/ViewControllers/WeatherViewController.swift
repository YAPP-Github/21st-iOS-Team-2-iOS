//
//  WeatherViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit

public final class WeatherViewController: UIViewController {
    
    enum Section {
        case today
        case anotherDay
        
        init?(index: Int) {
            switch index {
            case 0: self = .today
            case 1: self = .anotherDay
            default: return nil
            }
        }
        
    }
    
    private var coordinator: WeatherCoordinatorInterface
    private var viewModel: WeatherViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    public init(coordinator: WeatherCoordinatorInterface, viewModel: WeatherViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var locationView: LocationView = {
        let locationView = LocationView("성북구 정릉동")
        let tappedLoacationView = UITapGestureRecognizer(target: self, action: #selector(didTapLoactionView(_:)))
        locationView.addGestureRecognizer(tappedLoacationView)
        return locationView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(WeatherCell.self)
        collectionView.register(WeeklyWeatherCell.self)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: HeaderView.className)
        collectionView.register(WeatherInfoHeaderView.self, forSupplementaryViewOfKind: WeatherInfoHeaderView.className)
        return collectionView
    }()

}

private extension WeatherViewController {
    
    func setUp() {
        setUpLayout()
        setUpNavigationBar()
        setUpDataSource()
        applySnapshot()
    }
    
    func setUpNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left")?
                .withConfiguration(UIImage.SymbolConfiguration(font: .preferredFont(for: .body, weight: .bold))),
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func didTapLoactionView(_ sender: UITapGestureRecognizer) {
        coordinator.showSettingAddress()
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.finished()
    }
    
    func setUpLayout() {
        view.addSubviews(locationView, collectionView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                let section = Section(index: indexPath.section)
                switch section {
                case .today:
                    let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)
                    return cell
                    
                case .anotherDay:
                    let cell = collectionView.dequeueReusableCell(WeeklyWeatherCell.self, for: indexPath)
                    cell?.setUp()
                    return cell
                    
                default:
                    return UICollectionViewCell()
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
                
            case FooterView.className:
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
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.today])
        snapshot.appendItems(Array(0...23).map { _ in UUID() })
        snapshot.appendSections([.anotherDay])
        snapshot.appendItems(Array(0...10).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = Section(index: sectionNumber)
            switch section {
            case .today: return self?.weatherSectionLayout()
            case .anotherDay: return self?.anotherDaySectionLayout()
            default: return nil
            }
        }
    }
    
    func weatherSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(74),
            heightDimension: .absolute(72)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .zero, leading: 10, bottom: 28, trailing: 10)
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
                elementKind: FooterView.className, alignment: .bottom)
        ]
        return section
    }
    
    func anotherDaySectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(72)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .zero, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 16
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(UIScreen.main.bounds.width),
                    heightDimension: .absolute(50)
                ),
                elementKind: HeaderView.className, alignment: .top)
        ]
        return section
    }
}
