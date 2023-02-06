//
//  AlbumListSection.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/06.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

enum AlbumListSection {
    case album

    init?(index: Int) {
        switch index {
        case 0: self = .album
        default: return nil
        }
    }
}
