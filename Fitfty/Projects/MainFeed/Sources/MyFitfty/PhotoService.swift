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
        static let titleText = "최근 항목"
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
    
    // 앨범들 가져오기
    func getAlbums() -> [AlbumInfo] {
        // 일반 앨범 가져오기
        var allAlbums = [AlbumInfo]()
       
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = Const.predicate
        let standardAlbum = PHAsset.fetchAssets(with: fetchOptions)
        allAlbums.append(
            .init(
                identifier: nil,
                name: Const.titleText,
                photoCount: standardAlbum.count,
                album: standardAlbum,
                thumbNailImage: assetToImage(asset: standardAlbum[0])
            )
        )
        
        // 스마트 앨범 가져오기 (ex 즐겨찾는 항목)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: PHFetchOptions()
        )
        guard 0 < smartAlbums.count else {
            return allAlbums
        }
        smartAlbums.enumerateObjects { smartAlbum, index, pointer in
            guard index <= smartAlbums.count - 1 else {
                pointer.pointee = true
                return
            }
            if smartAlbum.estimatedAssetCount == NSNotFound {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = Const.predicate
                fetchOptions.sortDescriptors = Const.sortDescriptors
                let smartAlbums = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
                if smartAlbums.count > 0 {
                    allAlbums.append(
                        .init(
                            identifier: smartAlbum.localIdentifier,
                            name: smartAlbum.localizedTitle ?? Const.titleText,
                            photoCount: smartAlbums.count,
                            album: smartAlbums,
                            thumbNailImage: self.assetToImage(asset: smartAlbums[0])
                        )
                    )
                }
            }
        }
        return allAlbums
    }
    
    func getAlbums(completion: @escaping ([AlbumInfo]) -> Void) {
        // 일반 앨범 가져오기
        var allAlbums = [AlbumInfo]()
        defer {
            completion(allAlbums)
        }
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = Const.predicate
        let standardAlbum = PHAsset.fetchAssets(with: fetchOptions)
        allAlbums.append(
            .init(
                identifier: nil,
                name: Const.titleText,
                photoCount: standardAlbum.count,
                album: standardAlbum,
                thumbNailImage: assetToImage(asset: standardAlbum[0])
            )
        )
        
        // 스마트 앨범 가져오기 (ex 즐겨찾는 항목)
        let smartAlbums = PHAssetCollection.fetchAssetCollections(
            with: .smartAlbum,
            subtype: .any,
            options: PHFetchOptions()
        )
        guard 0 < smartAlbums.count else {
            return
        }
        smartAlbums.enumerateObjects { smartAlbum, index, pointer in
            guard index <= smartAlbums.count - 1 else {
                pointer.pointee = true
                return
            }
            if smartAlbum.estimatedAssetCount == NSNotFound {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = Const.predicate
                fetchOptions.sortDescriptors = Const.sortDescriptors
                let smartAlbums = PHAsset.fetchAssets(in: smartAlbum, options: fetchOptions)
                guard 0 < smartAlbums.count else {
                    return
                }
                allAlbums.append(
                    .init(
                        identifier: smartAlbum.localIdentifier,
                        name: smartAlbum.localizedTitle ?? Const.titleText,
                        photoCount: smartAlbums.count,
                        album: smartAlbums,
                        thumbNailImage: self.assetToImage(asset: smartAlbums[0])
                    )
                )
            }
        }
    }
    
    // 특정 앨범의 PHAssets 가져오기
    func getPHAssets(album: PHFetchResult<PHAsset>, completion: @escaping ([PHAsset]) -> Void) {
        guard 0 < album.count else {
            return
        }
        var phAssets = [PHAsset]()
        
        album.enumerateObjects { asset, index, stopPointer in
            guard index <= album.count - 1 else {
                stopPointer.pointee = true
                return
            }
            phAssets.append(asset)
        }
        
        completion(phAssets)
    }
    
    // PHAsset -> UIImage
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
        options.deliveryMode = .opportunistic
        
        manager.requestImage(
            for: asset,
            targetSize: .zero,
            contentMode: .aspectFill,
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
