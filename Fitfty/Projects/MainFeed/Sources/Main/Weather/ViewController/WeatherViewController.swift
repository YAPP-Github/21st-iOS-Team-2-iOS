//
//  WeatherViewController.swift
//  MainFeed
//
//  Created by Ari on 2023/01/17.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine
import Common

public final class WeatherViewController: UIViewController {
    
    private var viewModel: WeatherViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var coordinator: WeatherCoordinatorInterface
    private var dataSource: UICollectionViewDiffableDataSource<WeatherSectionKind, WeatherCellModel>?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.input.viewDidLoad()
    }
    
    public init(coordinator: WeatherCoordinatorInterface, viewModel: WeatherViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        coordinator.finished()
    }
    
    private lazy var locationView: LocationView = {
        let locationView = LocationView("성북구 정릉동")
        let tappedLoacationView = UITapGestureRecognizer(target: self, action: #selector(didTapLoactionView(_:)))
        locationView.addGestureRecognizer(tappedLoacationView)
        locationView.isHidden = true
        return locationView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = CommonAsset.Colors.primaryBlueLight.color
        control.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(WeatherCell.self)
        collectionView.register(WeeklyWeatherCell.self)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: HeaderView.className)
        collectionView.register(WeatherInfoHeaderView.self, forSupplementaryViewOfKind: WeatherInfoHeaderView.className)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white.withAlphaComponent(0.2), alpha: 1)
        loadingView.startAnimating()
        return loadingView
    }()
    
    private lazy var errorNotiView: ErrorNotiView = {
        let errorNotiView = ErrorNotiView(
            title: "잠시 후 다시 확인해주세요.",
            description: """
                         지금 서비스와 연결이 어려워요.
                         문제를 해결하기 위해 노력하고 있어요.
                         잠시 후 다시 확인해주세요.
                         """
        )
        errorNotiView.setBackButtonTarget(target: self, action: #selector(didTapPrevButton(_:)))
        errorNotiView.setMainButtonTarget(target: self, action: #selector(didTapMainButton(_:)))
        errorNotiView.isHidden = true
        return errorNotiView
    }()

}

private extension WeatherViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .currentLocation(let address):
                    self?.locationView.update(location: "\(address.secondName) \(address.thirdName)")
                    
                case .errorMessage(let message):
                    self?.showErrorNotiView()
                    self?.showAlert(message: message)
                    
                case .isLoading(let isLoading):
                    isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
                    
                case .isRefreshLoading(let isLoading):
                    isLoading ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
                    
                case .sections(let sections):
                    self?.hideErrorNotiView()
                    self?.applySnapshot(sections)
                }
            }).store(in: &cancellables)
    }
    
    func setUp() {
        setUpLayout()
        setUpNavigationBar()
        setUpDataSource()
    }
    
    func setUpNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc func didTapLoactionView(_ sender: UITapGestureRecognizer) {
        coordinator.showSettingAddress()
    }
    
    @objc func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.finished()
    }
    
    func setUpLayout() {
        view.addSubviews(locationView, collectionView, loadingIndicatorView, errorNotiView)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            locationView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            loadingIndicatorView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            loadingIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorNotiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorNotiView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorNotiView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorNotiView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<WeatherSectionKind, WeatherCellModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case .short(let weather):
                    let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)
                    cell?.setUp(
                        hour: weather.date.toString(.meridiemHour),
                        image: weather.forecast.icon,
                        temp: weather.temp,
                        isCurrentTime: weather.isCurrent
                    )
                    return cell ?? UICollectionViewCell()
                case .mid(let weather):
                    let cell = collectionView.dequeueReusableCell(WeeklyWeatherCell.self, for: indexPath)
                    if indexPath.item == 0 {
                        cell?.highlighted()
                    }
                    cell?.setUp(weather: weather)
                    return cell ?? UICollectionViewCell()
                }
            })
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            switch elementKind {
            case HeaderView.className:
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: HeaderView.className,
                    for: indexPath
                ) as? HeaderView
                headerView?.setUp(
                    largeTitle: "10일간 날씨예보",
                    smallTitle: "기상청에서 제공하는 정보를 알려드려요.",
                    largeTitleFont: FitftyFont.appleSDBold(size: 24).font ?? .systemFont(ofSize: 24),
                    smallTitleFont: FitftyFont.appleSDSemiBold(size: 13).font ?? .systemFont(ofSize: 13),
                    smallTitleColor: CommonAsset.Colors.gray04.color,
                    largeTitleTopAnchorConstant: 24,
                    smallTitleTopAchorConstant: 4
                )
                return headerView ?? UICollectionReusableView()
                
            case FooterView.className:
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: FooterView.className,
                    for: indexPath
                )
                
            case WeatherInfoHeaderView.className:
                guard let self = self else {
                    return UICollectionReusableView()
                }
                let reusableView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: WeatherInfoHeaderView.className,
                    for: indexPath
                ) as? WeatherInfoHeaderView
                reusableView?.setUp(viewModel: self.viewModel.output.weatherInfoViewModel)
                return reusableView
                
            default: return UICollectionReusableView()
            }
            
        }
        collectionView.dataSource = dataSource
    }
    
    func applySnapshot(_ sections: [WeatherSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherSectionKind, WeatherCellModel>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        snapshot.reloadSections([.today])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = WeatherSectionKind(index: sectionNumber)
            switch section {
            case .today: return self?.weatherSectionLayout()
            case .anotherDay: return self?.anotherDaySectionLayout()
            default: return nil
            }
        }
    }
    
    func weatherSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(72),
            heightDimension: .absolute(86)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 14, leading: 10, bottom: 28, trailing: 10)
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
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        section.interGroupSpacing = 16
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width - 40),
                    heightDimension: .absolute(80)
                ),
                elementKind: HeaderView.className, alignment: .top)
        ]
        return section
    }
    
    func showErrorNotiView() {
        errorNotiView.isHidden = false
        locationView.isHidden = true
    }
    
    func hideErrorNotiView() {
        errorNotiView.isHidden = true
        locationView.isHidden = false
    }
    
    @objc func didTapPrevButton(_ sender: FitftyButton) {
        viewModel.input.refresh()
    }
    
    @objc func didTapMainButton(_ sender: FitftyButton) {
        viewModel.input.refresh()
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        viewModel.input.didScrollRefreshControl()
    }
}
