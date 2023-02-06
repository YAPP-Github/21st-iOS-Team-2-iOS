//
//  AlbumListViewModel.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/06.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

protocol AlbumListViewModelInput {
    
    var input: AlbumListViewModelInput { get }
    func getAlbums() -> [AlbumInfo]
    
}

protocol AlbumListViewModelOutput {
    
    var selectedAlbumIndex: Int { get }
    
}

public final class AlbumListViewModel: AlbumListViewModelInput {
    var input: AlbumListViewModelInput { self }
    
    public init() { }
    
    func getAlbums() -> [AlbumInfo] {
        var albums = [AlbumInfo]()
        PhotoService.shared.getAlbums { allAlbums in
            albums = allAlbums
        }
        return albums
    }
    
}
