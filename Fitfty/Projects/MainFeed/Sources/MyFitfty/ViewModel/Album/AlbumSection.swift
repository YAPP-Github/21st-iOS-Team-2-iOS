//
//  AlbumSection.swift
//  MainFeed
//
//  Created by 임영선 on 2023/02/07.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation
import Photos

public struct AlbumSection {
    let sectionKind: AlbumSectionKind
    var items: [PHAsset]
}

public enum AlbumSectionKind {
    case album

    init?(index: Int) {
        switch index {
        case 0: self = .album
        default: return nil
        }
    }
}
