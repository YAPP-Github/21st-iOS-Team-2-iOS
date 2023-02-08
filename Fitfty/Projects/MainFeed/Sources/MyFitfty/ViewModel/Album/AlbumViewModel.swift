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
    func didTapUpload(isSelected: Bool)
    
}

protocol AlbumViewModelOutput {
    
    var output: AlbumViewModelOutput { get }
    func selectImage(index: Int)
    
}

public final class AlbumViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var currentAlbum: [PHAsset] = []
    
    public init() { }
    
}

extension AlbumViewModel: AlbumViewModelInput {
    
    var input: AlbumViewModelInput { self }

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
        currentState.send(.reloadAlbum(albumInfo.name))
        currentState.send(.sections([
            AlbumSection(
                sectionKind: .album,
                items: currentAlbum
            )
        ]))
    }
    
    func didTapUpload(isSelected: Bool) {
        guard isSelected else {
            return
        }
        currentState.send(.completed(true))
    }
    
}

extension AlbumViewModel: AlbumViewModelOutput {
    
    var output: AlbumViewModelOutput { self }
    
    func selectImage(index: Int) {
        let phAsset = currentAlbum[index]
        PhotoService.shared.fetchImage(
            asset: phAsset,
            size: .init(width: 3200, height: 3200),
            contentMode: .aspectFill
        ) {  image in
            var dateToString: String?
            if let date = phAsset.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = DateFormat.yyMMddDot.rawValue
                dateToString = dateFormatter.string(from: date)
            }
            
            var latitude: String?; var longitude: String?
            if let location = phAsset.location {
                latitude = String(location.coordinate.latitude)
                longitude = String(location.coordinate.longitude)
            }
            
            let phAssetInfo = PHAssetInfo(
                image: image,
                latitude: latitude,
                longitude: longitude,
                date: dateToString
            )
            NotificationCenter.default.post(name: .selectPhAsset, object: phAssetInfo)
        }
    }
    
}

extension AlbumViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([AlbumSection])
        case reloadAlbum(String)
        case completed(Bool)
    }
    
}
