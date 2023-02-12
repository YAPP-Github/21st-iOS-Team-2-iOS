//
//  PermissionViewController.swift
//  Auth
//
//  Created by Watcha-Ethan on 2023/01/25.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Photos
import AdSupport
import AppTrackingTransparency

import Core

final public class AuthPermissionViewController: UIViewController {
    private let coordinator: AuthCoordinatorInterface
    private let contentView = AuthPermissionView()
    
    public override func loadView() {
        self.view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(coordinator: AuthCoordinatorInterface) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        configureButtonTarget()
    }
    
    private func configureButtonTarget() {
        contentView.setNextButtonTarget(target: self, action: #selector(didTapNextButton))
    }
    
    @objc
    private func didTapNextButton() {
        requestPermission()
        
        /// - NOTE: 임시로 메인피드로 보내주는 코드, 온보딩 작업 완료 후 지워질 코드
        coordinator.pushMainFeedView()
    }
    
    private func requestPermission() {
        requestLocationPermission()
        requestAlbumAuthorizationPermission()
        requestPushNotificationPermission()
        requestTrackingPermission()
    }
    
    private func requestLocationPermission() {
        _ = LocationManager.shared
    }
    
    private func requestAlbumAuthorizationPermission() {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { _ in }
    }
    
    private func requestPushNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    private func requestTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { _ in }
    }
}
