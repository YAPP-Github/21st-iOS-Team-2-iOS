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

protocol AlbumViewModelInput {
    
    var input: AlbumViewModelInput { get }
    func viewDidLoad()
    
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

}

extension AlbumViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([AlbumSection])
    }

}
