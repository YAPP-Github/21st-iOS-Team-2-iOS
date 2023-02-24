//
//  NicknameViewController.swift
//  Onboarding
//
//  Created by Watcha-Ethan on 2023/02/11.
//  Copyright © 2023 Fitfty. All rights reserved.
//

import UIKit
import Combine

import Common

final public class NicknameViewController: UIViewController {
    private let coordinator: OnboardingCoordinatorInterface
    
    private let contentView = NicknameView()
    private let viewModel: NicknameViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public override func loadView() {
        self.view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init(viewModel: NicknameViewModel, coordinator: OnboardingCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        configure()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewModel.checkNicknameAvailable(contentView.getNickname())
        self.view.endEditing(true)
    }
    
    private func configure() {
        configureNavigationBar()
        configureNicknameTextField()
        configureNextButtonTarget()
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .changeNextButtonState(let isEnabled):
                    self?.contentView.setNextButtonStyle(isEnabled ? .enabled : .disabled)
                    self?.contentView.setNicknameTextFieldStyle(isEnabled ? .focused : .normal)
                    
                case .pushMainFeedView:
                    self?.coordinator.pushMainFeedView()
                
                case .showErrorAlert(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$hasAvailableString
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccess in
                self?.contentView.setFirstWarningState(isSuccess: isSuccess)
            }
            .store(in: &cancellables)
        
        viewModel.$hasNoOverlappingNickname
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccess in
                self?.contentView.setSecondWarningState(isSuccess: isSuccess)
            }
            .store(in: &cancellables)
        
        contentView.nicknameTextPublisher()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink { [weak self] nickname in
                self?.viewModel.checkNicknameAvailable(nickname)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.contentView.setNextButtonMoveUp(notification as NSNotification)
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.contentView.setNextButtonMoveDown(notification as NSNotification)
            }
            .store(in: &cancellables)
    }
    
    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(
            image: CommonAsset.Images.btnArrowleft.image,
            style: .plain,
            target: self,
            action: #selector(didTapBackButton(_:))
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func configureNicknameTextField() {
        contentView.setNicknameTextFieldDelegate(self)
    }
    
    private func configureNextButtonTarget() {
        contentView.setNextButtonTarget(target: self, action: #selector(didTapNextButton))
    }
    
    @objc
    private func didTapNextButton() {
        viewModel.didTapNextButton()
    }
    
    @objc
    private func didTapBackButton(_ sender: UITapGestureRecognizer) {
        coordinator.pop()
    }
}

extension NicknameViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.checkNicknameAvailable(textField.text ?? "")
        textField.resignFirstResponder()
        return true
    }
}
