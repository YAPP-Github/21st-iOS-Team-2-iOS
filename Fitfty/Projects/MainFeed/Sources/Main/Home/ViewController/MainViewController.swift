//
//  MainViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Combine
import Common
import Core

public final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let coordinator: MainCoordinatorInterface
    private var dataSource: UICollectionViewDiffableDataSource<MainSectionKind, MainCellModel>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(WeatherCell.self)
        collectionView.register(StyleCell.self)
        collectionView.register(CodyCell.self)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: HeaderView.className)
        collectionView.register(WeatherInfoHeaderView.self, forSupplementaryViewOfKind: WeatherInfoHeaderView.className)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var locationView: LocationView = {
        let loacationView = LocationView("성북구 정릉동")
        loacationView.isHidden = true
        return loacationView
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.input.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.refresh()
    }
    
    public init(coordinator: MainCoordinatorInterface, viewModel: MainViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainViewController {
    
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
                    
                case .sections(let sections):
                    self?.hideErrorNotiView()
                    self?.applySnapshot(sections)
                    self?.showWelcomeView()
                }
            }).store(in: &cancellables)
    }
    
    func showWelcomeView() {
        coordinator.showWelcomeSheet()
    }
    
    func setUp() {
        setUpLayout()
        setUpNavigationBar()
        setUpDataSource()
    }
    
    func setUpLayout() {
        view.backgroundColor = .white
        view.addSubviews(collectionView, loadingIndicatorView, errorNotiView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    
    func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationView)
        let tappedLoacationView = UITapGestureRecognizer(target: self, action: #selector(didTapLoactionView(_:)))
        locationView.addGestureRecognizer(tappedLoacationView)
    }
    
    @objc func didTapLoactionView(_ sender: UITapGestureRecognizer) {
        coordinator.showSettingAddress()
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MainSectionKind, MainCellModel>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                switch item {
                case .weather(let weather):
                    let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)
                    cell?.setUp(
                        hour: weather.date.toString(.meridiemHour),
                        image: weather.forecast.icon,
                        temp: weather.temp,
                        isCurrentTime: weather.isCurrent
                    )
                    return cell ?? UICollectionViewCell()
                    
                case .styleTag:
                    let items = ["포멀", "캐주얼", "미니멀", "포멀", "캐주얼", "미니멀", "포멀"]
                    let cell = collectionView.dequeueReusableCell(StyleCell.self, for: indexPath)
                    cell?.setUp(text: items[indexPath.item])
                    return cell ?? UICollectionViewCell()
                    
                case .cody:
                    let cell = collectionView.dequeueReusableCell(CodyCell.self, for: indexPath)
                    cell?.addProfileViewGestureRecognizer(self, action: #selector(self.didTapProfileStackView))
                    return cell
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
                    largeTitle: "오늘의 핏프티",
                    smallTitle: "날씨에 맞는 코디 추천",
                    largeTitleFont: FitftyFont.appleSDBold(size: 24).font ?? .systemFont(ofSize: 24),
                    smallTitleFont: FitftyFont.appleSDSemiBold(size: 14).font ?? .systemFont(ofSize: 14),
                    smallTitleColor: CommonAsset.Colors.gray04.color,
                    largeTitleTopAnchorConstant: 24,
                    smallTitleTopAchorConstant: 4
                )
                return headerView
                
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
                reusableView?.setUp(viewModel: self.viewModel.weatherInfoViewModel)
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapWeather(_:)))
                reusableView?.addGestureRecognizer(tapGesture)
                return reusableView
                
            default: return UICollectionReusableView()
            }
            
        }
        collectionView.dataSource = dataSource
    }
    
    func applySnapshot(_ sections: [MainFeedSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<MainSectionKind, MainCellModel>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        snapshot.reloadSections([.weather])
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = MainSectionKind(index: sectionNumber)
            switch section {
            case .weather: return self?.weatherSectionLayout()
            case .style: return self?.styleSectionLayout()
            case .cody: return self?.codySectionLayout()
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
        section.contentInsets = .init(top: 8, leading: 10, bottom: 25, trailing: 10)
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
    
    func styleSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(35)
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
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width - 40),
                    heightDimension: .absolute(80)
                ),
                elementKind: HeaderView.className, alignment: .top)
        ]
        return section
    }
    
    func codySectionLayout() -> NSCollectionLayoutSection? {
        let imageSize: CGFloat = max(view.safeAreaLayoutGuide.layoutFrame.height - 380, 256)
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(imageSize),
            heightDimension: .absolute(imageSize)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: layoutSize.widthDimension,
                heightDimension: layoutSize.heightDimension
            ),
            subitems: [.init(layoutSize: layoutSize)]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .zero, leading: 20, bottom: .zero, trailing: 20)
        section.interGroupSpacing = 16
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    @objc func didTapWeather(_ sender: UIGestureRecognizer? = nil) {
        coordinator.showWeatherInfo()
    }
    
    @objc func didTapProfileStackView(_ sender: Any?) {
        coordinator.showProfile(profileType: .userProfile)
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
    
}

extension MainViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = MainSectionKind(index: indexPath.section)
        
        switch section {
        case .weather:
            didTapWeather()
        case .cody:
            coordinator.showPost(profileType: .userProfile)
        default: return
        }
    }
    
}
