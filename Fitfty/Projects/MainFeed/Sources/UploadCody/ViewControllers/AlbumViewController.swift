//
//  AlbumViewController.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Common
import Photos

final public class AlbumViewController: UIViewController {
    
    private let coordinator: AlbumCoordinatorInterface
    
    enum Section: CaseIterable {
        case main
    }
    
    private lazy var navigationBarView: BarView = {
        let barView = BarView()
        barView.setCancelButtonTarget(target: self, action: #selector(didTapCancelButton(_:)))
        barView.setTitleViewTarget(target: self, action: #selector(didTapTitleView(_:)))
        return barView
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("업로드", for: .normal)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: albumLayout())
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(AlbumCell.self)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, UUID>?
    
    private var albums: [AlbumInfo]?
    
    private var currentAlbumIndex = 0 {
        didSet {
            if let albums = albums {
                PhotoService.shared.getPHAssets(album: albums[currentAlbumIndex].album) { [weak self] phAssets in
                    self?.phAssets = phAssets
                }
            }
        }
    }
    
    private var currentAlbum: PHFetchResult<PHAsset>? {
        if let albums = albums,
           currentAlbumIndex <= albums.count-1 {
            return albums[currentAlbumIndex].album
        }
        return nil
    }
    
    private var phAssets = [PHAsset]() {
        didSet {
            applySnapshot()
        }
    }
    
    private var selectedIndex: Int?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    override public func removeFromParent() {
        super.removeFromParent()
        coordinator.dismiss()
    }
    
    public init(coordinator: AlbumCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setConstraintsLayout()
        setDataSource()
        applySnapshot()
        setPhotoService()
        setUploadButton()
    }
    
    private func setPhotoService() {
        PhotoService.shared.delegate = self
        getAlbums()
    }
    
    private func setUploadButton() {
        if selectedIndex != nil {
            uploadButton.setTitleColor(.white, for: .normal)
            uploadButton.backgroundColor = .black
        } else {
            uploadButton.setTitleColor(CommonAsset.Colors.gray06.color, for: .normal)
            uploadButton.backgroundColor = CommonAsset.Colors.gray03.color
        }
    }
    
    private func getAlbums() {
        PhotoService.shared.getAlbums(completion: { [weak self] albums in
            self?.albums = albums
        })
        
        if let albums = albums {
            PhotoService.shared.getPHAssets(album: albums[currentAlbumIndex].album) { [weak self] phAssets in
                self?.phAssets = phAssets
            }
        }
    }
    
    private func setConstraintsLayout() {
        view.addSubviews(navigationBarView, collectionView, uploadButton)
        
        let collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor)
        collectionViewTopConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            navigationBarView.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBarView.heightAnchor.constraint(equalToConstant: 76),
            
            collectionViewTopConstraint,
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -152),
            
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uploadButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 32),
            uploadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56)
        ])
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, UUID>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, _ in
                guard let self = self else {
                    return UICollectionViewCell()
                }
                let cell = collectionView.dequeueReusableCell(AlbumCell.self, for: indexPath)
                
                PhotoService.shared.fetchImage(
                    asset: self.phAssets[indexPath.item],
                    size: .init(width: 368, height: 356),
                    contentMode: .aspectFit
                ) { [weak cell] image in
                    DispatchQueue.main.async {
                        cell?.setImage(image: image)
                    }
                }
                return cell
            })
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0..<phAssets.count).map { _ in UUID() })
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
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        coordinator.dismiss()
    }
    
    @objc private func didTapTitleView(_ sender: UITapGestureRecognizer) {
        print(#function)
    }
}

// 사진 접근 권한: 선택된 사진
extension AlbumViewController: PHPhotoLibraryChangeObserver {
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        getAlbums()
    }
}

extension AlbumViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        setUploadButton()
    }
}
