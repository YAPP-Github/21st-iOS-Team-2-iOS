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
    
    var output: AlbumViewModelOutput { get }
   
}

public final class AlbumViewModel: AlbumViewModelInput {
    
    var input: AlbumViewModelInput { self }
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    
    public init() { }
    
    func viewDidLoad() {
        let recentAlbum = PhotoService.shared.getRecentAlbum()
        let phAssets = PhotoService.shared.getPHAssets(album: recentAlbum)
    
        currentState.send(.sections([
            AlbumSection(
                sectionKind: .album,
                items: phAssets
            )
        ]))
    }
    
    func getAlbum(_ albumInfo: AlbumInfo) {
        let phAssets = PhotoService.shared.getPHAssets(album: albumInfo.album)
        currentState.send(.reloadAlbum([
            AlbumSection(
                sectionKind: .album,
                items: phAssets
            )], albumInfo.name)
        )
        
    }
    
    func getPhAsset(_ phAsset: PHAsset) -> UIImage {
        let image = PhotoService.shared.assetToImage(asset: phAsset)
        return image
    }
    
}

extension AlbumViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([AlbumSection])
        case reloadAlbum([AlbumSection], String)
    }
    
}
