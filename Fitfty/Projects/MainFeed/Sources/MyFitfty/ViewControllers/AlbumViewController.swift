//
//  AlbumViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Combine
import Photos

final public class AlbumViewController: UIViewController {
    
    private let coordinator: AlbumCoordinatorInterface
    private let viewModel: AlbumViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView(title: "최근 항목", isChevronButtonHidden: false)
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        barView.setTitleViewTarget(target: self, action: #selector(didTapTitleView(_:)))
        return barView
    }()
    
    private lazy var uploadButton: FitftyButton = {
        let button = FitftyButton(style: .disabled, title: "업로드")
        button.addTarget(self, action: #selector(didTapUploadButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: albumLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(AlbumCell.self)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<AlbumSectionKind, PHAsset>?
   
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        bind()
        viewModel.input.viewDidLoad()
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }
    
    public init(coordinator: AlbumCoordinatorInterface, viewModel: AlbumViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setConstraintsLayout()
        setDataSource()
        setNotificationCenter()
    }
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
    @objc private func didTapTitleView(_ sender: UITapGestureRecognizer) {
        coordinator.showAlbumList()
    }
    
    @objc private func getAlbum(_ notification: Notification) {
        guard let albumInfo = notification.object as? AlbumInfo else {
            return
        }
        viewModel.input.getAlbum(albumInfo)
    }
    
    @objc private func didTapUploadButton(_ sender: Any?) {
        viewModel.input.didTapUpload()
    }
    
}

private extension AlbumViewController {
    
    func bind() {
        viewModel.state.compactMap { $0 }
            .sinkOnMainThread(receiveValue: { [weak self] state in
                switch state {
                case .sections(let sections):
                    self?.applySnapshot(sections)
                case .reloadAlbum(let title):
                    self?.navigationBarView.setTitle(title: title)
                    self?.collectionView.scrollToItem(at: .init(item: 0, section: 0), at: .top, animated: false)
                    self?.uploadButton.setStyle(.disabled)
                case .completed(let completed):
                    guard completed else {
                        return
                    }
                    self?.coordinator.dismiss()
                }
            }).store(in: &cancellables)
    }
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(getAlbum), name: .selectAlbum, object: nil)
    }
    
    func setConstraintsLayout() {
        view.addSubviews(navigationBarView, collectionView, uploadButton)
        
        let collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor)
        collectionViewTopConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            
            collectionViewTopConstraint,
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height*0.613),
            
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uploadButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 32),
            uploadButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<AlbumSectionKind, PHAsset>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, phAssets in
                let cell = collectionView.dequeueReusableCell(AlbumCell.self, for: indexPath)
                
                PhotoService.shared.fetchImage(
                    asset: phAssets,
                    size: .init(width: 368, height: 356),
                    contentMode: .aspectFit
                ) { [weak cell] image in
                    DispatchQueue.main.async {
                        cell?.setImage(image: image)
                    }
                }
                return cell ?? UICollectionViewCell()
            })
    }
    
    func applySnapshot(_ sections: [AlbumSection]) {
        var snapshot = NSDiffableDataSourceSnapshot<AlbumSectionKind, PHAsset>()
        sections.forEach {
            snapshot.appendSections([$0.sectionKind])
            snapshot.appendItems($0.items)
        }
        dataSource?.apply(snapshot)
        
    }
    
    func albumLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/3)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        uploadButton.setStyle(.enabled)
        viewModel.input.didTapImage(index: indexPath.row)
    }
}
