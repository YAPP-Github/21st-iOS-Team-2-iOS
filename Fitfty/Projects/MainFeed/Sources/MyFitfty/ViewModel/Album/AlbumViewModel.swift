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
    func didTapUpload()
    func didTapImage(index: Int)
    
}

protocol AlbumViewModelOutput {
    
    var output: AlbumViewModelOutput { get }
    func selectImage()
    
}

public final class AlbumViewModel {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    private var currentAlbum: [PHAsset] = []
    private var selectedIndex: Int?
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
        selectedIndex = nil
        currentState.send(.reloadAlbum(albumInfo.name))
        currentState.send(.sections([
            AlbumSection(
                sectionKind: .album,
                items: currentAlbum
            )
        ]))
    }
    
    func didTapUpload() {
        guard selectedIndex != nil else {
            return
        }
        currentState.send(.completed(true))
        selectImage()
    }
    
    func didTapImage(index: Int) {
        self.selectedIndex = index
    }
    
}

extension AlbumViewModel: AlbumViewModelOutput {
    
    var output: AlbumViewModelOutput { self }
    
    func selectImage() {
        guard let selectedIndex = selectedIndex else {
            return
        }
        let phAsset = currentAlbum[selectedIndex]
        PhotoService.shared.fetchImage(
            asset: phAsset,
            size: .init(width: 3200, height: 3200),
            contentMode: .aspectFill
        ) {  image in
            var latitude: Double?; var longitude: Double?
            if let location = phAsset.location {
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
            }
            
            let phAssetInfo = PHAssetInfo(
                image: image,
                latitude: latitude,
                longitude: longitude,
                date: phAsset.creationDate
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
