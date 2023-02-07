//
//  UploadCodyViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Photos

final public class MyFitftyViewController: UIViewController {
    
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
    
    private var coordinator: MyFitftyCoordinatorInterface
    private var myFitftyType: MyFitftyType
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private var styleTagItems : [(styleTag: StyleTag, isSelected: Bool)] = [
        (.minimal, false),
        (.modern, false),
        (.casual, false),
        (.street, false),
        (.lovely, false),
        (.hip, false),
        (.luxury, false)
    ]
    
    private var weatherTagItems: [(weatherTag: WeatherTag, isSelected: Bool)] = [
        (.coldWaveWeather, false),
        (.coldWeather, false),
        (.chillyWeather, false),
        (.warmWeather, false),
        (.hotWeather, false)
    ]
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(ContentCell.self)
        collectionView.register(StyleTagCell.self)
        collectionView.register(WeatherTagCell.self)
        collectionView.register(Common.HeaderView.self, forSupplementaryViewOfKind: Common.HeaderView.className)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: FooterView.className)
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var disableRightBarButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle(myFitftyType.buttonTitle, for: .normal)
        button.setTitleColor(CommonAsset.Colors.gray03.color, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDSemiBold(size: 16).font
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var enableRightBarButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle(myFitftyType.buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FitftyFont.appleSDMedium(size: 15).font
        button.frame = CGRect(x: 0, y: 0, width: 65, height: 37)
        button.backgroundColor = .black
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintLayout()
        setUpNavigationBar()
        setUpDataSource()
        applySnapshot()
        setNotificationCenter()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 24).font ?? UIFont.systemFont(ofSize: 24)]
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenter()
    }
    
    public init(coordinator: MyFitftyCoordinatorInterface, myFitftyType: MyFitftyType) {
        self.coordinator = coordinator
        self.myFitftyType = myFitftyType
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = myFitftyType.navigationBarTitle
        
        let leftButton: UIButton = {
          let button = UIButton()
            button.setImage(UIImage(systemName: "xmark"), for: .normal)
            button.tintColor = .black
            button.setPreferredSymbolConfiguration(.init(scale: .medium), forImageIn: .normal)
            button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
            return button
        }()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        switch myFitftyType {
        case .uploadMyFitfty:
            navigationItem.rightBarButtonItem = disableRightBarButton
        case .modifyMyFitfty:
            navigationItem.rightBarButtonItem = enableRightBarButton
        }
        
    }
    
    private func setUpConstraintLayout() {
        view.addSubviews(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollToBottom),
            name: .scrollToBottom,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollToTop),
            name: .scrollToTop,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getPHAssetInfo),
            name: .selectPhAsset,
            object: nil
        )
    }
    
    private func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(
            self,
            name: .scrollToTop,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .scrollToBottom,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: .selectPhAsset,
            object: nil
        )
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
    @objc func didTapUploadButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
    @objc func scrollToBottom() {
        guard collectionView.numberOfSections > 0 else {
            return
        }
        let indexPath = IndexPath(
            item: collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1) - 1,
            section: collectionView.numberOfSections - 1
        )
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func scrollToTop() {
        guard collectionView.numberOfSections > 0 else {
            return
        }
        collectionView.setContentOffset(.zero, animated: true)
    }
    
    @objc func getPHAssetInfo() {
        
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension MyFitftyViewController {
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, _ in
                guard let self = self else {
                    return UICollectionViewCell()
                }
                let section = Section(index: indexPath.section)
                switch section {
                case .content:
                    let cell = collectionView.dequeueReusableCell(ContentCell.self, for: indexPath)
                    cell?.setActionUploadPhotoButton(self, action: #selector(self.didTapUploadPhotoButton))
                    
                    switch self.myFitftyType {
                    case .modifyMyFitfty:
                        cell?.setUp(codyImage: CommonAsset.Images.profileSample.image, content: "오늘의 핏프티~")
                        cell?.setDisableEditting()
                        
                    case .uploadMyFitfty:
                        break
                    }
                    
                    return cell ?? UICollectionViewCell()
                    
                case .weatherTag:
                    let cell = collectionView.dequeueReusableCell(WeatherTagCell.self, for: indexPath)
                    cell?.setUp(
                        weahterTag: self.weatherTagItems[indexPath.item].weatherTag,
                        isSelected: self.weatherTagItems[indexPath.item].isSelected
                    )
                    return cell ?? UICollectionViewCell()
                    
                case .styleTag:
                    let cell = collectionView.dequeueReusableCell(StyleTagCell.self, for: indexPath)
                    cell?.setUp(
                        styleTag: self.styleTagItems[indexPath.item].styleTag,
                        isSelected: self.styleTagItems[indexPath.item].isSelected
                    )
                    return cell
                    
                default:
                    return UICollectionViewCell()
                }
            })
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let section = Section(index: indexPath.section)
            switch elementKind {
            case Common.HeaderView.className:
                if section == .weatherTag {
                    let reusableView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: Common.HeaderView.className,
                        for: indexPath
                    ) as? Common.HeaderView
                    
                    reusableView?.setUp(
                        largeTitle: "날씨 태그를 골라주세요.",
                        smallTitle: "사진을 업로드하면 촬영한 날의 날씨 정보를 자동으로 불러와요.",
                        largeTitleFont: FitftyFont.appleSDBold(size: 16).font ?? .systemFont(ofSize: 16),
                        smallTitleFont: FitftyFont.appleSDMedium(size: 14).font ?? .systemFont(ofSize: 14),
                        smallTitleColor: CommonAsset.Colors.gray05.color,
                        largeTitleTopAnchorConstant: 32,
                        smallTitleTopAchorConstant: 8
                    )
                    return reusableView
                } else if section == .styleTag {
                    let reusableView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: Common.HeaderView.className,
                        for: indexPath
                    ) as? Common.HeaderView
                    
                    reusableView?.setUp(
                        largeTitle: "스타일 태그를 골라주세요.",
                        smallTitle: nil,
                        largeTitleFont: FitftyFont.appleSDBold(size: 16).font ?? .systemFont(ofSize: 16),
                        smallTitleFont: nil,
                        smallTitleColor: nil,
                        largeTitleTopAnchorConstant: 28,
                        smallTitleTopAchorConstant: 0
                    )
                    return reusableView
                } else {
                    return nil
                }
                
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
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func applyTagSnapshot() {
        if var snapshot = dataSource?.snapshot() {
            snapshot.deleteSections([.weatherTag])
            snapshot.appendSections([.weatherTag])
            snapshot.appendItems(Array(0..<weatherTagItems.count).map { _ in UUID() })
            snapshot.deleteSections([.styleTag])
            snapshot.appendSections([.styleTag])
            snapshot.appendItems(Array(0..<styleTagItems.count).map { _ in UUID() })
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
        
}

// MARK: - UICollectionViewCompositionalLayout
extension MyFitftyViewController {
    
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
            heightDimension: .absolute(UIScreen.main.bounds.width*0.936+290)
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
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width),
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
                
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width-40),
                    heightDimension: .estimated(50)
                ),
                elementKind: Common.HeaderView.className, alignment: .top)
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
        section.contentInsets = .init(top: 20, leading: 20, bottom: 28, trailing: 20)
        section.interGroupSpacing = 8
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width-40),
                    heightDimension: .estimated(82)
                ),
                elementKind: Common.HeaderView.className, alignment: .top),
            
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(
                    widthDimension: .absolute(view.safeAreaLayoutGuide.layoutFrame.width-40),
                    heightDimension: .absolute(1)
                ),
                elementKind: FooterView.className, alignment: .bottom)
        ]
        return section
    }
}

// MARK: - UICollectionViewDelegate
extension MyFitftyViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(index: indexPath.section)
        switch section {
        case .weatherTag:
            for index in weatherTagItems.indices {
                if indexPath.item == index {
                    weatherTagItems[index].isSelected = true
                } else {
                    weatherTagItems[index].isSelected = false
                }
            }
            applyTagSnapshot()
            
        case .styleTag:
            for index in styleTagItems.indices {
                if indexPath.item == index {
                    styleTagItems[index].isSelected = true
                } else {
                    styleTagItems[index].isSelected = false
                }
            }
            applyTagSnapshot()
            
        default:
            break
        }
    }
}

// MARK: - AlbumAuthorization
extension MyFitftyViewController {
    @objc private func didTapUploadPhotoButton(_ sender: UIButton) {
        requestAlbumAuthorization { [weak self] isAuthorized in
            if isAuthorized {
                PhotoService.shared.getAlbums(completion: { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.coordinator.showAlbum()
                    }
                })
            } else {
                self?.showAlertGoToSetting(
                    title: "현재 앨범 사용에 대한 접근 권한이 없습니다.",
                    message: "설정 > 핏프티 탭에서 접근을 활성화 할 수 있습니다."
                )
            }
        }
    }
    
    func requestAlbumAuthorization(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                completion([.authorized, .limited].contains(where: { $0 == status }))
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                completion(status == .authorized)
            }
        }
    }
    
    func showAlertGoToSetting(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAlert = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        let goToSettingAlert = UIAlertAction(
            title: "설정으로 이동하기",
            style: .default) { _ in
                guard
                    let settingURL = URL(string: UIApplication.openSettingsURLString),
                    UIApplication.shared.canOpenURL(settingURL)
                else { return }
                UIApplication.shared.open(settingURL, options: [:])
            }
        [cancelAlert, goToSettingAlert]
            .forEach(alertController.addAction(_:))
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
