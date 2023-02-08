//
//  PhotoService.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import UIKit
import Photos

final class PhotoService: NSObject {
    static let shared = PhotoService()
    weak var delegate: PHPhotoLibraryChangeObserver?
    
    override private init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    private enum Const {
        static let predicate: NSPredicate = .init(
            format: "mediaType == %d",
            PHAssetMediaType.image.rawValue
        )
        static let sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false),
            NSSortDescriptor(key: "modificationDate", ascending: false)
        ]
    }
    
    let imageManager = PHCachingImageManager()
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func getAlbums(completion: @escaping ([AlbumInfo]) -> Void) {
        var allAlbums = [AlbumInfo]()
        defer {
            completion(allAlbums)
        }
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: PHFetchOptions()
        )
        guard 0 < smartAlbums.count else {
            return
        }
        allAlbums = smartAlbumsToAlbumInfos(smartAlbums)
    }
    
    func getAlbums() -> [AlbumInfo] {
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: PHFetchOptions()
        )
        guard 0 < smartAlbums.count else {
            return []
        }
        return smartAlbumsToAlbumInfos(smartAlbums)
    }
    
    func smartAlbumsToAlbumInfos(_ smartAlbums: PHFetchResult<PHAssetCollection>) -> [AlbumInfo] {
        var albumInfos = [AlbumInfo]()
        smartAlbums.enumerateObjects { smartAlbum, index, pointer in
            
            if index <= smartAlbums.count - 1 {
                guard smartAlbum.estimatedAssetCount == NSNotFound else {
                    return
                }
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = Const.predicate
                fetchOptions.sortDescriptors = Const.sortDescriptors
                let smartAlbums = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
                guard 0 < smartAlbums.count else {
                    return
                }
                albumInfos.append(
                    .init(
                        identifier: smartAlbum.localIdentifier,
                        name: self.englishToKorean(title: smartAlbum.localizedTitle),
                        photoCount: smartAlbums.count,
                        album: smartAlbums,
                        thumbnailImage: self.assetToImage(asset: smartAlbums[0])
                    )
                )
            } else {
                pointer.pointee = true
            }
        }
        return albumInfos
    }
    
    func getRecentAlbum() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = Const.predicate
        fetchOptions.sortDescriptors = Const.sortDescriptors
        let recentAlbum = PHAsset.fetchAssets(with: fetchOptions)
        return recentAlbum
    }
    
    func getPHAssets(album: PHFetchResult<PHAsset>) -> [PHAsset] {
        var phAssets = [PHAsset]()
        album.enumerateObjects { asset, index, stopPointer in
            if index <= album.count - 1 {
                phAssets.append(asset)
            } else {
                stopPointer.pointee = true
            }
        }
        return phAssets
    }
    
    func fetchImage(
        asset: PHAsset,
        size: CGSize,
        contentMode: PHImageContentMode,
        completion: @escaping (UIImage) -> Void
    ) {
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.deliveryMode = .highQualityFormat
        
        self.imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: contentMode,
            options: option
        ) { image, _ in
            guard let image = image else {
                return
            }
            completion(image)
        }
    }
    
    func assetToImage(asset: PHAsset) -> UIImage {
        var image = UIImage()
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .opportunistic
        
        manager.requestImage(
            for: asset,
            targetSize: .init(width: 368, height: 356),
            contentMode: .aspectFit,
            options: options
        ) { (result, _) -> Void in
            image = result ?? UIImage()
        }
        return image
    }
    
}

// 사진 접근 권한: 선택된 사진
extension PhotoService: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        self.delegate?.photoLibraryDidChange(changeInstance)
    }
}

extension PhotoService {
    func englishToKorean(title: String?) -> String {
        guard let title = title else {
            return "폴더명 없음"
        }
        switch title {
        case "Recents": return "최근 항목"
        case "Favorites": return "즐겨찾는 항목"
        case "Selfies": return "셀피"
        case "Panoramas": return "파노라마"
        case "Screenshots": return "스크린샷"
        case "Hidden": return "가려진 항목"
        case "Portrait": return "인물 사진"
        case "Bursts": return "고속 연사 촬영"
        default: return title
        }
    }
}
