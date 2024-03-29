//
//  Notification.Name+extension.swift
//  Common
//
//  Created by 임영선 on 2023/01/13.
//  Copyright © 2023 Fitfty. All rights reserved.
//
import UIKit

public extension Notification.Name {
    static let scrollToBottom = Notification.Name(rawValue: "scrollToBottom")
    static let scrollToTop = Notification.Name(rawValue: "scrollToTop")
    static let selectAlbum = Notification.Name(rawValue: "selectAlbum")
    static let selectPhAsset = Notification.Name(rawValue: "selectPhAsset")
    static let resignKeyboard = Notification.Name(rawValue: "resignKeyboard")
    static let showKeyboard = Notification.Name(rawValue: "showKeyboard")
    static let showLoginNotification = Notification.Name(rawValue: "showLoginNotification")
}
