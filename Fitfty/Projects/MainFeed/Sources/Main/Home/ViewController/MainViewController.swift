//
//  MainViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Common
import Combine

public final class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let coordinator: MainCoordinatorInterface
    private var dataSource: UICollectionViewDiffableDataSource<MainViewSection, UUID>?
    
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
    
    private lazy var locationView = {
        return LocationView("성북구 정릉동")
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.input.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWelcomeView()
        viewModel.input.viewDidAppear()
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
                    self?.showAlert(message: message)
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
        applySnapshot()
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
    
    func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: locationView)
        let tappedLoacationView = UITapGestureRecognizer(target: self, action: #selector(didTapLoactionView(_:)))
        locationView.addGestureRecognizer(tappedLoacationView)
    }
    
    @objc func didTapLoactionView(_ sender: UITapGestureRecognizer) {
        coordinator.showSettingAddress()
    }
    
    func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MainViewSection, UUID>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, _ in
                let section = MainViewSection(index: indexPath.section)
                switch section {
                case .weather:
                    let cell = collectionView.dequeueReusableCell(WeatherCell.self, for: indexPath)
                    return cell ?? UICollectionViewCell()
                    
                case .style:
                    let items = ["포멀", "캐주얼", "미니멀", "포멀", "캐주얼", "미니멀", "포멀"]
                    let cell = collectionView.dequeueReusableCell(StyleCell.self, for: indexPath)
                    cell?.setUp(text: items[indexPath.item])
                    return cell ?? UICollectionViewCell()
                    
                case .cody:
                    let cell = collectionView.dequeueReusableCell(CodyCell.self, for: indexPath)
                    cell?.addProfileViewGestureRecognizer(self, action: #selector(self.didTapProfileStackView))
                    return cell
                    
                default:
                    return UICollectionViewCell()
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
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<MainViewSection, UUID>()
        snapshot.appendSections([.weather])
        snapshot.appendItems(Array(0...23).map { _ in UUID() })
        snapshot.appendSections([.style])
        snapshot.appendItems(Array(0...6).map { _ in UUID() })
        snapshot.appendSections([.cody])
        snapshot.appendItems(Array(0...10).map { _ in UUID() })
        dataSource?.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = MainViewSection(index: sectionNumber)
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
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .absolute(256),
            heightDimension: .absolute(256)
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
        coordinator.showUserProfile()
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = MainViewSection(index: indexPath.section)
        
        switch section {
        case .weather:
            didTapWeather()
        case .cody:
            coordinator.showUserPost()
        default: return
        }
    }
    
}
