//
//  MidlandFcstResponse.swift
//  Core
//
//  Created by Ari on 2023/01/21.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import Foundation

// MARK: - MidlandFcstResponse
struct MidlandFcstResponse: Codable {
    let response: MidlandFcstResult
}

// MARK: - Response
struct MidlandFcstResult: Codable {
    let header: MidlandFcstHeader
    let body: MidlandFcstBody?
}

// MARK: - Body
struct MidlandFcstBody: Codable {
    let dataType: String
    let items: MidlandFcstItems
    let pageNo: Int
    let numOfRows: Int
    let totalCount: Int
}

// MARK: - Items
struct MidlandFcstItems: Codable {
    let item: [MidlandFcstItem]
}

// MARK: - Item
struct MidlandFcstItem: Codable {
    let regID: String
    let rnSt3Am: Int
    let rnSt3Pm: Int
    let rnSt4Am: Int
    let rnSt4Pm: Int
    let rnSt5Am: Int
    let rnSt5Pm: Int
    let rnSt6Am: Int
    let rnSt6Pm: Int
    let rnSt7Am: Int
    let rnSt7Pm: Int
    let rnSt8: Int
    let rnSt9: Int
    let rnSt10: Int
    let wf3Am: String
    let wf3Pm: String
    let wf4Am: String
    let wf4Pm: String
    let wf5Am: String
    let wf5Pm: String
    let wf6Am: String
    let wf6Pm: String
    let wf7Am: String
    let wf7Pm: String
    let wf8: String
    let wf9: String
    let wf10: String

    enum CodingKeys: String, CodingKey {
        case regID = "regId"
        case rnSt3Am, rnSt3Pm, rnSt4Am, rnSt4Pm, rnSt5Am, rnSt5Pm, rnSt6Am,
             rnSt6Pm, rnSt7Am, rnSt7Pm, rnSt8, rnSt9, rnSt10, wf3Am, wf3Pm,
             wf4Am, wf4Pm, wf5Am, wf5Pm, wf6Am, wf6Pm, wf7Am, wf7Pm, wf8, wf9, wf10
    }
}

// MARK: - Header
struct MidlandFcstHeader: Codable {
    let resultCode: ResultCode
    let resultMsg: String
}

extension MidlandFcstItem {
    
    func forecast(_ day: Int, meridiem: Meridiem) -> (forecast: String, precipitation: Int)? {
        switch (day, meridiem) {
        case (3, .am): return (wf3Am, rnSt3Am)
        case (3, .pm): return (wf3Pm, rnSt3Pm)
        case (4, .am): return (wf4Am, rnSt4Am)
        case (4, .pm): return (wf4Pm, rnSt4Pm)
        case (5, .am): return (wf5Am, rnSt5Am)
        case (5, .pm): return (wf5Pm, rnSt5Pm)
        case (6, .am): return (wf6Am, rnSt6Am)
        case (6, .pm): return (wf6Pm, rnSt6Pm)
        case (7, .am): return (wf7Am, rnSt7Am)
        case (7, .pm): return (wf7Pm, rnSt7Pm)
        case (8, .am), (8, .pm): return (wf8, rnSt8)
        case (9, .am), (9, .pm): return (wf9, rnSt9)
        case (10, .am), (10, .pm): return (wf10, rnSt10)
        default: return nil
        }
    }
}

public enum Meridiem: CaseIterable {
    case am
    case pm
}
