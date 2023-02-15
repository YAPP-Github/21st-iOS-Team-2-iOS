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
        requestTrackingPermission()
        
        coordinator.pushOnboardingFlow()
    }
    
    private func requestTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { _ in }
    }
}
