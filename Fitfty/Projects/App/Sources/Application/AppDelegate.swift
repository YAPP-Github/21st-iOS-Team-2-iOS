//
//  AppDelegate.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

import Core
import Common

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        AppAppearance.setUpAppearance()
        
        // MARK: - Social Login 초기화
        KakaoSDK.initSDK(appKey: APIKey.kakaoAppKey)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
