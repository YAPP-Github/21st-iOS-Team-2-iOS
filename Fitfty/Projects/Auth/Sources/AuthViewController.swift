//
//  Auth.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Combine

final public class AuthViewController: UIViewController {
    public weak var coordinator: AuthCoordinatorInterface?
    
    private let viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    public init(viewModel: AuthViewModel, coordinator: AuthCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .presentKakaoLoginView:
                    self?.coordinator?.presentKakaoLoginView()
                    
                case .pushOnboardingView:
                    self?.coordinator?.pushOnboardingView()
                    
                case .doSomething:
                    // Do Something
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func didTapKakaoLoginButton() {
        viewModel.didTapKakaoLogin()
    }
    
    private func didTapRequestKakaoLoginButton() {
        viewModel.requestKakaoLogin()
    }
}
