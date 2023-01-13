//
//  AlbumInfo.swift
//  MainFeed
//
//  Created by 임영선 on 2023/01/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Photos

struct AlbumInfo: Hashable {
    let identifier: String?
    let name: String
    let count: Int
    let album: PHFetchResult<PHAsset>
}
