//
//  GenderViewController.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine

import Common

final public class GenderViewController: UIViewController {
    private let coordinator: OnboardingCoordinatorInterface
    
    private let contentView = GenderView()
    private let viewModel: GenderViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public override func loadView() {
        self.view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    public init(viewModel: GenderViewModel, coordinator: OnboardingCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureNavigationBar()
        configureButtonTarget()
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.contentView.setNextButtonStyle(isEnabled ? .enabled : .disabled)
                
                case .pushStyleView:
                    self?.coordinator.pushStyleView()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$maleButtonIsPressed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPressed in
                self?.contentView.setMaleButtonStyle(style: isPressed ? .isPressed : .normal)
            }
            .store(in: &cancellables)
        
        viewModel.$femaleButtonIsPressed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPressed in
                self?.contentView.setFemaleButtonStyle(style: isPressed ? .isPressed : .normal)
            }
            .store(in: &cancellables)
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func configureButtonTarget() {
        contentView.setNextButtonTarget(target: self, action: #selector(didTapNextButton))
        contentView.setMaleButtonTarget(target: self, action: #selector(didTapMaleButton))
        contentView.setFemaleButtonTarget(target: self, action: #selector(didTapFemaleButton))
    }
    
    @objc
    private func didTapNextButton() {
        viewModel.didTapNextButton()
    }
    
    @objc
    private func didTapMaleButton() {
        viewModel.didTapMaleButton()
    }
    
    @objc
    private func didTapFemaleButton() {
        viewModel.didTapFemaleButton()
    }
    
    @objc
    private func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.pop()
    }
}
