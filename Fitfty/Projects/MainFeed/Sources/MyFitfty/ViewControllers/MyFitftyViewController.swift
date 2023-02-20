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
import Combine

final public class MyFitftyViewController: UIViewController {
    
    private var coordinator: MyFitftyCoordinatorInterface
    private var myFitftyType: MyFitftyType
    private let viewModel: MyFitftyViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private var dataSource: UICollectionViewDiffableDataSource<MyFitftySectionKind, MyFitftyCellModel>?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(ContentCell.self)
        collectionView.register(StyleTagCell.self)
        collectionView.register(WeatherTagCell.self)
        collectionView.register(GenderCell.self)
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
    
    private lazy var loadingIndicatorView: LoadingView = {
        let loadingView: LoadingView = .init(backgroundColor: .white.withAlphaComponent(0.2), alpha: 1)
        loadingView.stopAnimating()
        return loadingView
    }()
    
    private var selectedImage: UIImage?
    private var selectedImageFilepath: String?
    private var contentText = "내 코디에 대한 설명을 남겨보세요."
    private var imageInfoMessage: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.input.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotificationCenter()
    }
    
    public init(coordinator: MyFitftyCoordinatorInterface, myFitftyType: MyFitftyType, viewModel: MyFitftyViewModel) {
        self.coordinator = coordinator
        self.myFitftyType = myFitftyType
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setUpConstraintLayout()
        setUpNavigationBar()
        setUpDataSource()
        setNotificationCenter()
    }
    
    @objc func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
    @objc func didTapUploadButton(_ sender: UIButton) {
        enableRightBarButton.isEnabled = false
        viewModel.input.didTapUpload()
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
    
    @objc func getPHAssetInfo(_ notification: Notification) {
        let phAssetInfo = notification.object as? PHAssetInfo
        guard let phAssetInfo = phAssetInfo else {
            return
        }
        viewModel.input.getPhAssetInfo(phAssetInfo)
    }
    
    @objc func resignKeyboard(_ sender: Any?) {
        NotificationCenter.default.post(name: .resignKeyboard, object: nil)
    }
}

private extension MyFitftyViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .sections(let sections, let animated):
                    self?.applySnapshot(sections, animated)
                case .codyImage(let image):
                    self?.selectedImage = image
                case .content(let text):
                    self?.contentText = text
                case .isEnabledUpload(let isEnabled):
                    self?.navigationItem.rightBarButtonItem =
                    isEnabled ? self?.enableRightBarButton : self?.disableRightBarButton
                case .errorMessage(let message):
                    self?.showAlert(message: message)
                case .isLoading(let isLoading):
                    isLoading ? self?.loadingIndicatorView.startAnimating() : self?.loadingIndicatorView.stopAnimating()
                case .imageInfoMessage(let message):
                    self?.imageInfoMessage = message
                case .completed(let isCompleted):
                    guard isCompleted else {
                        return
                    }
                    self?.coordinator.dismiss()
                case .codyFilepath(let filepath):
                    self?.selectedImageFilepath = filepath
                }
            }).store(in: &cancellables)
    }
    
    func setUpNavigationBar() {
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
    
    func setNavigationController() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: FitftyFont.appleSDBold(size: 24).font ?? UIFont.systemFont(ofSize: 24)]
    }
    
    func setUpConstraintLayout() {
        view.addSubviews(collectionView, loadingIndicatorView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            loadingIndicatorView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            loadingIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func setNotificationCenter() {
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
    
    func removeNotificationCenter() {
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
    
}

// MARK: ContentDelegate
extension MyFitftyViewController: ContentDelegate {
    func sendContent(text: String) {
        viewModel.input.editContent(text: text)
    }
}

// MARK: - UICollectionViewDiffableDataSource
extension MyFitftyViewController {
    
    private func setUpDataSource() {
        dataSource = UICollectionViewDiffableDataSource<MyFitftySectionKind, MyFitftyCellModel>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self = self else {
                    return UICollectionViewCell()
                }
                switch item {
                case .content:
                    let cell = collectionView.dequeueReusableCell(ContentCell.self, for: indexPath)
                    cell?.delegate = self
                    cell?.setActionUploadPhotoButton(self, action: #selector(self.didTapUploadPhotoButton))
                    switch self.myFitftyType {
                    case .modifyMyFitfty:
                        cell?.setDisableEditting()
                        cell?.setUp(content: self.contentText)
                        if let selectedImageFilepath = self.selectedImageFilepath {
                            cell?.setUp(filepath: selectedImageFilepath)
                        }
                        
                    case .uploadMyFitfty:
                        cell?.setUp(content: self.contentText)
                        if let selectedImage = self.selectedImage {
                            cell?.setUp(codyImage: selectedImage)
                            cell?.setHiddenBackgroundButton()
                        }
                    }
                    
                    return cell ?? UICollectionViewCell()
                    
                case .weatherTag(let weatherTag, let isSelected):
                    let cell = collectionView.dequeueReusableCell(WeatherTagCell.self, for: indexPath)
                    cell?.setUp(
                        weahterTag: weatherTag,
                        isSelected: isSelected
                    )
                    return cell
                    
                case .genderTag(let gender, let isSelected):
                    let cell = collectionView.dequeueReusableCell(GenderCell.self, for: indexPath)
                    cell?.setUp(
                        gender: gender,
                        isSelected: isSelected
                    )
                    return cell
                    
                case .styleTag(let styleTag, let isSelected):
                    let cell = collectionView.dequeueReusableCell(StyleTagCell.self, for: indexPath)
                    cell?.setUp(
                        styleTag: styleTag,
                        isSelected: isSelected
                    )
                    return cell
                }
            })
        
        dataSource?.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            let section = MyFitftySectionKind(index: indexPath.section)
            switch elementKind {
            case Common.HeaderView.className:
                if section == .weatherTag {
                    let reusableView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: Common.HeaderView.className,
                        for: indexPath
                    ) as? Common.HeaderView
                    
                    reusableView?.setUp(
                        largeTitle: "어떤 날씨에 입는 옷인가요?",
                        smallTitle: self.imageInfoMessage ?? "사진을 업로드하면 촬영한 날의 날씨 정보를 자동으로 불러와요.",
                        largeTitleFont: FitftyFont.appleSDSemiBold(size: 16).font ?? .systemFont(ofSize: 16),
                        smallTitleFont: FitftyFont.appleSDMedium(size: 14).font ?? .systemFont(ofSize: 14),
                        smallTitleColor: CommonAsset.Colors.gray05.color,
                        largeTitleTopAnchorConstant: 32,
                        smallTitleTopAchorConstant: 8
                    )
                    reusableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignKeyboard)))
                    return reusableView
                } else if section == .genderTag {
                    let reusableView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: elementKind,
                        withReuseIdentifier: Common.HeaderView.className,
                        for: indexPath
                    ) as? Common.HeaderView
                    
                    reusableView?.setUp(
                        largeTitle: "어떤 스타일인가요?",
                        smallTitle: nil,
                        largeTitleFont: FitftyFont.appleSDSemiBold(size: 16).font ?? .systemFont(ofSize: 16),
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
    
    private func applySnapshot(_ sections: [MyFitftySection], _ isCodyImage: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<MyFitftySectionKind, MyFitftyCellModel>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        if isCodyImage {
            snapshot.reloadSections([.weatherTag])
        }
        dataSource?.apply(snapshot, animatingDifferences: isCodyImage)
    }
        
}

// MARK: - UICollectionViewCompositionalLayout
extension MyFitftyViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionNumber, _) -> NSCollectionLayoutSection? in
            let section = MyFitftySectionKind(index: sectionNumber)
            switch section {
            case .content: return self?.contentSectionLayout()
            case .weatherTag: return self?.weatherTagSectionLayout()
            case .styleTag: return self?.styleTagSectionLayout()
            case .genderTag: return self?.genderTagSectionLayout()
            default: return nil
            }
        }
    }
    
    private func contentSectionLayout() -> NSCollectionLayoutSection? {
        let layoutSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(UIScreen.main.bounds.width*0.936+13+40+64)
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
    
    private func genderTagSectionLayout() -> NSCollectionLayoutSection? {
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
        if let section = MyFitftySectionKind(index: indexPath.section) {
            viewModel.input.didTapTag(section, index: indexPath.item)
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
