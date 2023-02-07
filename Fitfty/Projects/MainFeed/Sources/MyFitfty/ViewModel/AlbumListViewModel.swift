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

protocol AlbumListViewModelOutput {
    
    var ouput: AlbumListViewModelOutput { get }
    func viewDidLoad()
    
}

public final class AlbumListViewModel: AlbumListViewModelOutput {
    
    public var currentState: CurrentValueSubject<ViewModelState?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = .init()
    var ouput: AlbumListViewModelOutput { self }
   
    public init() { }
    
    func viewDidLoad() {
        currentState.send(.sections([
            AlbumListSection(
                sectionKind: .album,
                items: PhotoService.shared.getAlbums()
            )
        ]))
    }

}

extension AlbumListViewModel: ViewModelType {
    
    public var state: AnyPublisher<ViewModelState, Never> { currentState.compactMap { $0 }.eraseToAnyPublisher() }
    
    public enum ViewModelState {
        case sections([AlbumListSection])
    }

}
