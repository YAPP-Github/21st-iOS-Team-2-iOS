//
//  Auth.swift
//  ProjectDescriptionHelpers
//
//  Created by Ari on 2022/12/02.
//

import UIKit
import Combine
import MessageUI

import Core

final public class AuthViewController: UIViewController {
    private let coordinator: AuthCoordinatorInterface
    
    private let contentView = AuthView()
    private let viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public override func loadView() {
        self.view = contentView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    public init(viewModel: AuthViewModel, coordinator: AuthCoordinatorInterface) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureButtonTarget()
    }
    
    private func configureButtonTarget() {
        contentView.setEnterWithoutLoginButtonTarget(target: self, action: #selector(didTapEnterWithoutLoginButton))
        contentView.setLoginProblemButtonTarget(target: self, action: #selector(didTapLoginProblemButton))
        contentView.setKakaoButtonTarget(target: self, action: #selector(didTapKakaoButton))
        contentView.setAppleButtonTarget(target: self, action: #selector(didTapAppleButton))
    }
    
    private func bind() {
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .pushIntroView:
                    self?.coordinator.pushIntroView()
                case .pushMainFeedView:
                    break
                case .showErrorAlert(let error):
                    self?.showErrorAlert(error)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func didTapKakaoButton() {
        viewModel.didTapKakaoLogin()
    }
    
    @objc
    private func didTapAppleButton() {
        viewModel.didTapAppleLogin()
    }
    
    @objc
    private func didTapEnterWithoutLoginButton() {
        viewModel.didTapEnterWithoutLoginButton()
    }
    
    @objc
    private func didTapLoginProblemButton() {
        if MFMailComposeViewController.canSendMail() {
            let mailViewController = MFMailComposeViewController()
            mailViewController.mailComposeDelegate = self
            
            mailViewController.setToRecipients(["team.fitfty@gmail.com"])
            mailViewController.setSubject("로그인 문제")
            mailViewController.setMessageBody("로그인에 어떤 문제가 있나요?", isHTML: false)
            
            self.present(mailViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func showErrorAlert(_ error: Error) {
        let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    private func showSendMailErrorAlert() {
        let alertController = UIAlertController(title: "메일 전송 실패",
                                                message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension AuthViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        controller.dismiss(animated: true)
    }
}
