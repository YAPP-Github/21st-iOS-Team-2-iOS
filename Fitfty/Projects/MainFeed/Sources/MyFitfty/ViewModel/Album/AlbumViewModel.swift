//
//  AlbumViewModel.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine
import Photos
import UIKit

protocol AlbumViewModelInput {
    
    var input: AlbumViewModelInput { get }
    func viewDidLoad()
    func getAlbum(_ albumInfo: AlbumInfo)
    
}

protocol AlbumViewModelOutput {
    
    var output: AlbumListViewModelOutput { get }
    func selectImage(index: Int)
}

public final class AlbumViewModel: AlbumViewModelInput, AlbumListViewModelOutput {
    
    var input: AlbumViewModelInput { self }
    var output: AlbumListViewModelOutput { self }
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var currentAlbum: [PHAsset] = []
    
    public init() { }
    
    func viewDidLoad() {
        let recentAlbum = PhotoService.shared.getRecentAlbum()
        currentAlbum = PhotoService.shared.getPHAssets(album: recentAlbum)
    
        currentState.send(.sections([
            AlbumSection(
                sectionKind: .album,
                items: currentAlbum
            )
        ]))
    }
    
    func getAlbum(_ albumInfo: AlbumInfo) {
        currentAlbum = PhotoService.shared.getPHAssets(album: albumInfo.album)
        currentState.send(.reloadAlbum([
            AlbumSection(
                sectionKind: .album,
                items: currentAlbum
            )], albumInfo.name)
        )
    }
    
    func selectAlbum(index: Int) {
        let phAsset = currentAlbum[index]
        let image = PhotoService.shared.assetToImage(asset: phAsset)
        
        guard let date = phAsset.creationDate else {
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.yyMMddDot.rawValue
        let dateToString = dateFormatter.string(from: date)
        
        guard let location = phAsset.location else {
            return
        }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let phAssetInfo = PHAssetInfo(
            image: image,
            latitude: String(latitude),
            longitude: String(longitude),
            date: dateToString
        )
        NotificationCenter.default.post(name: .selectPhAsset, object: phAssetInfo)
    }
    
}

extension AlbumViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([AlbumSection])
        case reloadAlbum([AlbumSection], String)
    }
    
}
