//
//  AlbumListViewModel.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/06.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Common
import Combine

protocol AlbumListViewModelInput {
    
    var input: AlbumListViewModelInput { get }
    func viewDidLoad()
    
}

protocol AlbumListViewModelOutput {
    
    var output: AlbumListViewModelOutput { get }
    func selectAlbum(index: Int)
    
}

public final class AlbumListViewModel: AlbumListViewModelInput, AlbumListViewModelOutput {
   
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var input: AlbumListViewModelInput { self }
    var output: AlbumListViewModelOutput { self }
    let albums = PhotoService.shared.getAlbums()
    
    public init() { }
    
    func viewDidLoad() {
        currentState.send(.sections([
            AlbumListSection(
                sectionKind: .album,
                items: albums
            )
        ]))
    }
    
    func selectAlbum(index: Int) {
        let albumInfo = albums[index]
        NotificationCenter.default.post(name: .selectAlbum, object: albumInfo)
    }
    
}

extension AlbumListViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([AlbumListSection])
    }

}
