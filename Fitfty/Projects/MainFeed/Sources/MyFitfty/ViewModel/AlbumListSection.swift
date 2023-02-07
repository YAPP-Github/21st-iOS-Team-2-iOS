//
//  AlbumListSection.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/06.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

public struct AlbumListSection {
    let sectionKind: AlbumListSectionKind
    var items: [AlbumInfo]
}

public enum AlbumListSectionKind {
    case album

    init?(index: Int) {
        switch index {
        case 0: self = .album
        default: return nil
        }
    }
}
